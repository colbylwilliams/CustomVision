//
//  CustomVisionApi.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/14/18.
//

import Foundation

protocol CustomVisionApi {
    static var name: String { get }
    static var region: String { get }
    static var version: String { get }
    static var headerKey: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var hasValidIds: Bool { get }
    func headerValue(trainingKey: String, predictionKey: String) throws -> String
    func contentType(_ boundary: String?) -> String
}

extension CustomVisionApi {
    func url(withQuery query: String? = nil) -> URL? {
        return URL(string: urlString(withQuery: query))
    }
    func urlString(withQuery query: String? = nil) -> String {
        return "https://\(Self.region).api.cognitive.microsoft.com/customvision/\(Self.version)/\(Self.name)/\(self.path)\(query.valueOrEmpty)"
    }
    var headerKey: String {
        return Self.headerKey
    }
}

enum PredictionApi: CustomVisionApi {
    
    case predictImage(projectId: String)
    case predictImageUrl(projectId: String)
    case predictImageUrlWithNoStore(projectId: String)
    case predictImageWithNoStore(projectId: String)
    
    
    static var name: String = "Prediction"
    static var region: String = "southcentralus"
    static var version: String = "v1.1"
    static var headerKey: String = "Prediction-key"
    
    func headerValue(trainingKey: String, predictionKey: String) throws -> String {
        guard !predictionKey.isEmpty else { throw CustomVisionClientError.noPredictionKey }
        return predictionKey
    }
    
    func contentType(_ boundary: String? = nil) -> String {
        switch self {
        case .predictImage, .predictImageWithNoStore: return "multipart/form-data; boundary=\(boundary!)"
        default: return "application/json"
        }
    }
    
    var path: String {
        switch self {
        case let .predictImage(projectId):                  return "/\(projectId)/image"
        case let .predictImageUrl(projectId):               return "/\(projectId)/url"
        case let .predictImageUrlWithNoStore(projectId):    return "/\(projectId)/url/nostore"
        case let .predictImageWithNoStore(projectId):       return "/\(projectId)/image/nostore"
        }
    }
    
    var method: HttpMethod {
        return .post
    }
    
    var hasValidIds: Bool {
        switch self {
        case let .predictImage(projectId),
             let .predictImageUrl(projectId),
             let .predictImageUrlWithNoStore(projectId),
             let .predictImageWithNoStore(projectId):
            return !projectId.isEmpty
        }
    }
}

enum TrainingApi: CustomVisionApi {
    
    case createImagesFromData(projectId: String)
    case deleteImages(projectId: String)
    case createImagesFromFiles(projectId: String)
    case createImagesFromPredictions(projectId: String)
    case createImagesFromUrls(projectId: String)
    case createProject
    case getProjects
    case createTag(projectId: String)
    case getTags(projectId: String)
    case deleteImageTags(projectId: String)
    case postImageTags(projectId: String)
    case deleteIteration(projectId: String, iterationId: String)
    case getIteration(projectId: String, iterationId: String)
    case updateIteration(projectId: String, iterationId: String)
    case deletePrediction(projectId: String)
    case deleteProject(projectId: String)
    case getProject(projectId: String)
    case updateProject(projectId: String)
    case deleteTag(projectId: String, tagId: String)
    case getTag(projectId: String, tagId: String)
    case updateTag(projectId: String, tagId: String)
    case exportIteration(projectId: String, iterationId: String)
    case getExports(projectId: String, iterationId: String)
    case getAccountInfo
    case getDomain(domainId: String)
    case getDomains
    case getIterationPerformance(projectId: String, iterationId: String)
    case getIterations(projectId: String)
    case getTaggedImages(projectId: String)
    case getUntaggedImages(projectId: String)
    case queryPredictionResults(projectId: String)
    case quickTestImage(projectId: String)
    case quickTestImageUrl(projectId: String)
    case trainProject(projectId: String)
    
    static var name: String = "Training"
    static var region: String = "southcentralus"
    static var version: String = "v1.2"
    static var headerKey: String = "Training-key"
    
    func headerValue(trainingKey: String, predictionKey: String) throws -> String {
        guard !trainingKey.isEmpty else { throw CustomVisionClientError.noTrainingKey }
        return trainingKey
    }
    
    func contentType(_ boundary: String? = nil) -> String {
        switch self {
        case .createImagesFromData: return "multipart/form-data; boundary=\(boundary!)"
        default: return "application/json"
        }
    }
    
    var path: String {
        switch self {
        case let .createImagesFromData(projectId),
             let .deleteImages(projectId):                          return "projects/\(projectId)/images"
        case let .createImagesFromFiles(projectId):                 return "projects/\(projectId)/images/files"
        case let .createImagesFromPredictions(projectId):           return "projects/\(projectId)/images/predictions"
        case let .createImagesFromUrls(projectId):                  return "projects/\(projectId)/images/urls"
        case .createProject, .getProjects:                          return "projects"
        case let .createTag(projectId),
             let .getTags(projectId):                               return "projects/\(projectId)/tags"
        case let .deleteImageTags(projectId),
             let .postImageTags(projectId):                         return "projects/\(projectId)/images/tags"
        case let .deleteIteration(projectId, iterationId),
             let .getIteration(projectId, iterationId),
             let .updateIteration(projectId, iterationId):          return "projects/\(projectId)/iterations/\(iterationId)"
        case let .deletePrediction(projectId):                      return "projects/\(projectId)/predictions"
        case let .deleteProject(projectId),
             let .getProject(projectId),
             let .updateProject(projectId):                         return "projects/\(projectId)"
        case let .deleteTag(projectId, tagId),
             let .getTag(projectId, tagId),
             let .updateTag(projectId, tagId):                      return "projects/\(projectId)/tags/\(tagId)"
        case let .exportIteration(projectId, iterationId),
             let .getExports(projectId, iterationId):               return "projects/\(projectId)/iterations/\(iterationId)/export"
        case .getAccountInfo:                                       return "account"
        case let .getDomain(domainId):                              return "domains/\(domainId)"
        case .getDomains:                                           return "domains"
        case let .getIterationPerformance(projectId, iterationId):  return "projects/\(projectId)/iterations/\(iterationId)/performance"
        case let .getIterations(projectId):                         return "projects/\(projectId)/iterations"
        case let .getTaggedImages(projectId):                       return "projects/\(projectId)/images/tagged"
        case let .getUntaggedImages(projectId):                     return "projects/\(projectId)/images/untagged"
        case let .queryPredictionResults(projectId):                return "projects/\(projectId)/predictions/query"
        case let .quickTestImage(projectId):                        return "projects/\(projectId)/quicktest/image"
        case let .quickTestImageUrl(projectId):                     return "projects/\(projectId)/quicktest/url"
        case let .trainProject(projectId):                          return "projects/\(projectId)/train"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getProjects,
             .getTags,
             .getIteration,
             .getProject,
             .getTag,
             .getExports,
             .getAccountInfo,
             .getDomain,
             .getDomains,
             .getIterationPerformance,
             .getIterations,
             .getTaggedImages,
             .getUntaggedImages:
            return .get
        case .createImagesFromData,
             .createImagesFromFiles,
             .createImagesFromPredictions,
             .createImagesFromUrls,
             .createProject,
             .createTag,
             .postImageTags,
             .exportIteration,
             .queryPredictionResults,
             .quickTestImage,
             .quickTestImageUrl,
             .trainProject:
            return .post
        case .deleteImages,
             .deleteImageTags,
             .deleteIteration,
             .deletePrediction,
             .deleteProject,
             .deleteTag:
            return .delete
        case .updateIteration,
             .updateProject,
             .updateTag:
            return .patch
        }
    }
    
    var hasValidIds: Bool {
        switch self {
        case let .createImagesFromData(projectId),
             let .deleteImages(projectId),
             let .createImagesFromFiles(projectId),
             let .createImagesFromPredictions(projectId),
             let .createImagesFromUrls(projectId),
             let .createTag(projectId),
             let .getTags(projectId),
             let .deleteImageTags(projectId),
             let .postImageTags(projectId),
             let .deletePrediction(projectId),
             let .deleteProject(projectId),
             let .getProject(projectId),
             let .updateProject(projectId),
             let .getIterations(projectId),
             let .getTaggedImages(projectId),
             let .getUntaggedImages(projectId),
             let .queryPredictionResults(projectId),
             let .quickTestImage(projectId),
             let .quickTestImageUrl(projectId),
             let .trainProject(projectId):
            return !projectId.isEmpty
        case let .deleteTag(projectId, tagId),
             let .getTag(projectId, tagId),
             let .updateTag(projectId, tagId):
            return !projectId.isEmpty && !tagId.isEmpty
        case let .exportIteration(projectId, iterationId),
             let .deleteIteration(projectId, iterationId),
             let .getIteration(projectId, iterationId),
             let .updateIteration(projectId, iterationId),
             let .getExports(projectId, iterationId),
             let .getIterationPerformance(projectId, iterationId):
            return !projectId.isEmpty && !iterationId.isEmpty
        case let .getDomain(domainId):
            return !domainId.isEmpty
        case .getAccountInfo,
             .getDomains,
             .createProject,
             .getProjects:
            return true
        }
    }
}
