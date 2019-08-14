//
//  CustomVisionExport.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/24/18.
//

#if !os(watchOS)

import Foundation
import CoreML

public extension CustomVisionClient {
    
    func getModelUrl(fileManager: FileManager = FileManager.default, compiled: Bool = true) -> URL? {
        
        let appSupportDirectory = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileName = compiled ? modelName + "c/" : modelName
        
        let url = appSupportDirectory.appendingPathComponent(fileName)
        
        return fileManager.fileExists(atPath: url.path) ? url : nil
    }
    
    
    func trainAndDownloadCoreMLModel(withName name: String, progressUpdate update: @escaping (String) -> Void, _ completion: @escaping (Bool, String) -> Void) {
        
        modelName = name
        
        self.trainProject { r in
            
            switch r.result {
            case .success(let iteration) where iteration.Exportable:
                    update("Exporting Model...")
                    self.exportIteration(iteration, withDelay: self.pollDelay) { r in
                        switch r.result {
                        case .success(let export) where export.Status == .done && export.DownloadUri != nil:
                            return self.downloadExport(export, update, completion)
                        default: return self.getErrorMessage(from: r, update, completion)
                        }
                    }
            case .success(let iteration):
                self.getIteration(iteration, withDelay: self.pollDelay) { r in
                    switch r.result {
                    case .success(let iteration) where iteration.Exportable:
                        update("Exporting Model...")
                        self.exportIteration(iteration, withDelay: self.pollDelay) { r in
                            switch r.result {
                            case .success(let export) where export.Status == .done && export.DownloadUri != nil:
                                return self.downloadExport(export, update, completion)
                            default: return self.getErrorMessage(from: r, update, completion)
                            }
                        }
                    default: return self.getErrorMessage(from: r, update, completion)
                    }
                }
            case .failure:
                return self.getErrorMessage(from: r, update, completion)
            }
            update("Training Project...")
        }
    }
    
    func getIteration(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.getIteration(withId: iteration.Id) { r in
                switch r.result {
                case .success(let iteration) where !iteration.Exportable:
                    self.getIteration(iteration, withDelay: delay, completion)
                default: completion(r)
                }
            }
        }
    }
    
    func exportIteration(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<Export>) -> Void) {
        self.exportIteration(withId: iteration.Id, forPlatform: .coreML) { r in
            switch r.result {
            case .success(let export) where export.Status == .exporting:
                self.getExport(iteration, withDelay: delay) { r in
                    switch r.result {
                    case .success(let exports) where exports.first?.Status == .done && exports.first?.DownloadUri != nil:
                        completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: .success(export)))
                    case .success(let exports):
                        completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: exports.first != nil ? .success(exports.first!) : .failure(CustomVisionClientError.unknown)))
                    case .failure(let error):
                        completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: .failure(error)))
                    }
                }
            default: completion(r)
            }
        }
    }
    
    func getExport(_ iteration: Iteration, withDelay delay: Double, _ completion: @escaping (CustomVisionResponse<[Export]>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.getExports(fromIteration: iteration.Id) { r in
                switch r.result {
                    case .success(let exports) where exports.first?.Status == .exporting:
                        self.getExport(iteration, withDelay: delay, completion)
                default: completion(r)
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
}

#endif
