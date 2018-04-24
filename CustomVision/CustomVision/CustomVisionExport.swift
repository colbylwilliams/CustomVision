//
//  CustomVisionExport.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/24/18.
//

import Foundation
import CoreML

public extension CustomVisionClient {
    
    public func getModelUrl(fileManager: FileManager = FileManager.default, compiled: Bool = true) -> URL? {
        
        let appSupportDirectory = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileName = compiled ? modelName + "c/" : modelName
        
        let url = appSupportDirectory.appendingPathComponent(fileName)
        
        return fileManager.fileExists(atPath: url.path) ? url : nil
    }
    
    
    public func trainAndDownloadCoreMLModel(withName name: String, progressUpdate update: @escaping (String) -> Void, _ completion: @escaping (Bool, String) -> Void) {
        
        modelName = name
        
        self.trainProject { r in
            
            if let iteration = r.resource {
                
                if iteration.Exportable {
                    
                    update("Exporting Model...")
                    
                    self.exportIteration(iteration, withDelay: self.pollDelay) { r in
                        if let export = r.resource, export.Status == .done, let _ = export.DownloadUri {
                            return self.downloadExport(export, update, completion)
                        } else {
                            return self.getErrorMessage(from: r, update, completion)
                        }
                    }
                } else {
                    
                    self.getIteration(iteration, withDelay: self.pollDelay) { r in
                        
                        if let iteration = r.resource, iteration.Exportable {
                            
                            update("Exporting Model...")
                            
                            self.exportIteration(iteration, withDelay: self.pollDelay) { r in
                                if let export = r.resource, export.Status == .done, let _ = export.DownloadUri {
                                    return self.downloadExport(export, update, completion)
                                } else {
                                    return self.getErrorMessage(from: r, update, completion)
                                }
                            }
                        } else {
                            return self.getErrorMessage(from: r, update, completion)
                        }
                    }
                }
            } else {
                return self.getErrorMessage(from: r, update, completion)
            }
            
            update("Training Project...")
        }
    }
    
    func getIteration(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.getIteration(withId: iteration.Id) { r in
                if let i = r.resource, !i.Exportable {
                    self.getIteration(i, withDelay: delay, completion)
                } else {
                    completion(r)
                }
            }
        }
    }
    
    func exportIteration(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<Export>) -> Void) {
        self.exportIteration(withId: iteration.Id, forPlatform: .coreML) { r in
            if let e = r.resource, e.Status == .exporting {
                self.getExport(iteration, withDelay: delay) { r in
                    if let exports = r.resource, let export = exports.first, export.Status == .done, let _ = export.DownloadUri {
                        completion(CustomVisionResponse.init(request: r.request, data: r.data, response: r.response, result: .success(export)))
                    } else {
                        completion(CustomVisionResponse.init(request: r.request, data: r.data, response: r.response, result: (r.result.isSuccess ? .success(r.resource!.first!) : .failure(r.error!))))
                    }
                }
            } else {
                completion(r)
            }
        }
    }
    
    func getExport(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<[Export]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.getExports(fromIteration: iteration.Id) { r in
                if let exports = r.resource, let export = exports.first, export.Status == .exporting {
                    self.getExport(iteration, withDelay: delay, completion)
                } else {
                    completion(r)
                }
            }
        }
    }
    
    func downloadExport(_ export: Export, _ update: @escaping (String) -> Void, _ completion: @escaping (Bool, String) -> Void) {
        
        update("Downloading & Compiling Model...")
        
        guard let url = export.DownloadUri, export.Status == .done, export.Platform == .coreML else {
            completion(false, "Model Update Failed"); return
        }
        
        let session = URLSession.shared
        
        session.downloadTask(with: url) { (location, response, error) in
            
            if let error = error {
                
                print(error)
                completion(false, "Model Update Failed: \(error.localizedDescription)")
                
            } else if let location = location {
                
                let fileManager = FileManager.default
                let appSupportDirectory = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                
                let definitionUrl = appSupportDirectory.appendingPathComponent(self.modelName)
                
                do {
                    // if the file exists, replace it. Otherwise, copy the file to the destination.
                    if fileManager.fileExists(atPath: definitionUrl.path) {
                        _ = try fileManager.replaceItemAt(definitionUrl, withItemAt: location)
                    } else {
                        try fileManager.copyItem(at: location, to: definitionUrl)
                    }
                    
                    let compiledUrl = try MLModel.compileModel(at: definitionUrl)
                    
                    let permanentUrl = appSupportDirectory.appendingPathComponent(compiledUrl.lastPathComponent)
                    
                    if fileManager.fileExists(atPath: permanentUrl.path) {
                        _ = try fileManager.replaceItemAt(permanentUrl, withItemAt: compiledUrl)
                    } else {
                        try fileManager.copyItem(at: compiledUrl, to: permanentUrl)
                    }
                    
                    completion(true, "Model Update Successful")
                    
                } catch {
                    print("Error during copy: \(error.localizedDescription)")
                    completion(false, "Model Update Failed: \(error.localizedDescription)")
                }
            } else {
                print("donno")
                completion(false, "Model Update Failed: Unknown")
            }
        }.resume()
    }
    
    public func getErrorMessage<T>(from response: CustomVisionResponse<T>, _ update: @escaping (String) -> Void, _ completion: @escaping (Bool, String) -> Void) {
        
        //response.printResult()
        //response.printResponseData()
        
        if let data = response.data {
            if let errorMessage = try? decoder.decode(CustomVisionErrorMessage.self, from: data) {
                completion(false, errorMessage.Message)
            } else if let string = String(data: data, encoding: .utf8) {
                completion(false, string)
            } else {
                completion(false, "¯\\_(ツ)_/¯")
            }
        } else if let error = response.error {
            completion(false, error.localizedDescription)
        } else {
            completion(false, "¯\\_(ツ)_/¯")
        }
    }
}
