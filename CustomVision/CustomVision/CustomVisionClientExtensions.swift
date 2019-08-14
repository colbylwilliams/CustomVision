//
//  CustomVisionClientExtensions.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/25/18.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension CustomVisionClient {
    
    #if os(macOS)
    typealias UIImage = NSImage
    #endif
    
    
    func predict(image: UIImage, forApplication applicationId: String? = nil, forIteration iterationId: String? = nil, inProject projectId: String = defaultProjectId, withoutStoring noStore: Bool = false, completion: @escaping (CustomVisionResponse<ImagePredictionResult>) -> Void) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            return self.predict(image: data, forApplication: applicationId, forIteration: iterationId, inProject: projectId, withoutStoring: noStore, completion: completion)
        } else {
            completion(CustomVisionResponse(CustomVisionClientError.unknown))
        }
    }

    func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withTagIds tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
    
        let entries = images.map { ImageFileCreateEntry(Name: nil, Contents: $0.jpegData(compressionQuality: 1.0), TagIds: nil) }
        
        let batch = ImageFileCreateBatch(Images: entries, TagIds: tagIds)
        
        return self.createImages(inProject: projectId, from: batch, completion: completion)
    }

    func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withNewTagNamed tagName: String, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        self.createTag(inProject: projectId, withName: tagName, andDescription: nil) { r in
            
            if let tagId = r.resource?.Id, !tagId.isEmpty {
                
                return self.createImages(inProject: projectId, from: images, withTagIds: [tagId], completion: completion)
            
            } else if let error = r.error {
                
                completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: .failure(error)))
            
            } else {
             
                completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: .failure(CustomVisionClientError.unknown)))
            }
        }
    }
    
    func createImage(inProject projectId: String = defaultProjectId, from image: UIImage, withTagIds tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        return self.createImages(inProject: projectId, from: [image], withTagIds: tagIds, completion: completion)
    }
    
    func createImage(inProject projectId: String = defaultProjectId, from image: UIImage, withNewTagNamed tagName: String, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        return self.createImages(inProject: projectId, from: [image], withNewTagNamed: tagName, completion: completion)
    }
}

#if os(macOS)
fileprivate extension NSImage {
    func jpegData(compressionQuality: CGFloat) -> Data? {
        if let bits = self.representations.first as? NSBitmapImageRep,
            let data = bits.representation(using: .jpeg, properties: [:]) {
            
            return data
        }
        return nil
    }
}
#endif
