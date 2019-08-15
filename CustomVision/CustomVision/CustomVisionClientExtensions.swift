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
    
    
    func detect(image: UIImage, forApplication applicationId: String? = nil, forPublishedName publishedName: String, inProject projectId: String = defaultProjectId, withoutStoring noStore: Bool = false, completion: @escaping (CustomVisionResponse<ImagePrediction>) -> Void) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            return self.detect(image: data, forApplication: applicationId, forPublishedName: publishedName, inProject: projectId, withoutStoring: noStore, completion: completion)
        } else {
            completion(CustomVisionResponse(CustomVisionClientError.unknown))
        }
    }

    func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withTagIds tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
    
        let entries = images.map { ImageFileCreateEntry(name: nil, contents: $0.jpegData(compressionQuality: 1.0), tagIds: nil, regions: nil) }
        
        let batch = ImageFileCreateBatch(images: entries, tagIds: tagIds)
        
        return self.createImages(inProject: projectId, from: batch, completion: completion)
    }

    func createImages(inProject projectId: String = defaultProjectId, from images: [UIImage], withNewTagNamed tagName: String, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        self.createTag(inProject: projectId, withName: tagName, andDescription: nil) { r in
            
            switch r.result {
            case .success(let tag):
                return self.createImages(inProject: projectId, from: images, withTagIds: [tag.id], completion: completion)
            case .failure(let error):
                completion(CustomVisionResponse(request: r.request, data: r.data, response: r.response, result: .failure(error)));
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
