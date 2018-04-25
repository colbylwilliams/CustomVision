//
//  CustomVisionClientExtensions.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/25/18.
//

import Foundation
import UIKit

public extension CustomVisionClient {
    
    public func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withTagIds tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        let entries = images.map { ImageFileCreateEntry(Name: nil, Contents: UIImageJPEGRepresentation($0, 1.0), TagIds: nil) }
        
        let batch = ImageFileCreateBatch(Images: entries, TagIds: tagIds)
        
        return self.createImages(inProject: projectId, from: batch, completion: completion)
    }

    public func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withNewTagNamed tagName: String, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
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
    
    public func createImage(inProject projectId: String = defaultProjectId, from image: UIImage, withTagIds tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        return self.createImages(inProject: projectId, from: [image], withTagIds: tagIds, completion: completion)
    }
    
    public func createImage(inProject projectId: String = defaultProjectId, from image: UIImage, withNewTagNamed tagName: String, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        return self.createImages(inProject: projectId, from: [image], withNewTagNamed: tagName, completion: completion)
    }
}
