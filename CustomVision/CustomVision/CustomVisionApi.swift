//
//  CustomVisionApi.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/14/18.
//

import Foundation

protocol CustomVisionApi {
    static var name: String { get }
    static var version: String { get }
    static var service: String { get }
    static var headerKey: String { get }

    static var subscriptionRegion: AzureRegion { get set }

    var path: String { get }
    var method: HttpMethod { get }
    var hasValidIds: Bool { get }
    
    func contentType(_ boundary: String?) -> String
    func headerValue(trainingKey: String, predictionKey: String) throws -> String
}

extension CustomVisionApi {
    func url(withQuery query: String? = nil) -> URL? {
        return URL(string: urlString(withQuery: query))
    }
    func urlString(withQuery query: String? = nil) -> String {
        return "https://" + Self.subscriptionRegion.host + "/" + Self.service + "/" + Self.version + "/" + Self.name + "/" + self.path + query.valueOrEmpty
    }
    var headerKey: String {
        return Self.headerKey
    }
}

enum PredictionApi: CustomVisionApi {
    
    case classifyImage(projectId: String, publishedName: String)
    case classifyImageUrl(projectId: String, publishedName: String)
    case classifyImageUrlWithNoStore(projectId: String, publishedName: String)
    case classifyImageWithNoStore(projectId: String, publishedName: String)
    case detectImage(projectId: String, publishedName: String)
    case detectImageUrl(projectId: String, publishedName: String)
    case detectImageUrlWithNoStore(projectId: String, publishedName: String)
    case detectImageWithNoStore(projectId: String, publishedName: String)
    
    static var name: String = "Prediction"
    static var version: String = "v3.0"
    static var service: String = "customvision"
    static var headerKey: String = "Prediction-key"
    
    static var subscriptionRegion: AzureRegion = .southCentralUS

    func contentType(_ boundary: String? = nil) -> String {
        switch self {
        case .classifyImage,
             .classifyImageWithNoStore,
             .detectImage,
             .detectImageWithNoStore:
            return "multipart/form-data; boundary=\(boundary!)"
        default: return "application/json"
        }
    }
    
    func headerValue(trainingKey: String, predictionKey: String) throws -> String {
        guard !predictionKey.isEmpty else { throw CustomVisionClientError.noPredictionKey }
        return predictionKey
    }

    var path: String {
        switch self {
        case let .classifyImage(projectId, publishedName):                  return "/\(projectId)/classify/iterations/\(publishedName)/image"
        case let .classifyImageUrl(projectId, publishedName):               return "/\(projectId)/classify/iterations/\(publishedName)/url"
        case let .classifyImageUrlWithNoStore(projectId, publishedName):    return "/\(projectId)/classify/iterations/\(publishedName)/url/nostore"
        case let .classifyImageWithNoStore(projectId, publishedName):       return "/\(projectId)/classify/iterations/\(publishedName)/image/nostore"
        case let .detectImage(projectId, publishedName):                    return "/\(projectId)/detect/iterations/\(publishedName)/image"
        case let .detectImageUrl(projectId, publishedName):                 return "/\(projectId)/detect/iterations/\(publishedName)/url"
        case let .detectImageUrlWithNoStore(projectId, publishedName):      return "/\(projectId)/detect/iterations/\(publishedName)/url/nostore"
        case let .detectImageWithNoStore(projectId, publishedName):         return "/\(projectId)/detect/iterations/\(publishedName)/image/nostore"
        }
    }
    
    var method: HttpMethod {
        return .post
    }
    
    var hasValidIds: Bool {
        switch self {
        case let .classifyImage(projectId, publishedName),
             let .classifyImageUrl(projectId, publishedName),
             let .classifyImageUrlWithNoStore(projectId, publishedName),
             let .classifyImageWithNoStore(projectId, publishedName),
             let .detectImage(projectId, publishedName),
             let .detectImageUrl(projectId, publishedName),
             let .detectImageUrlWithNoStore(projectId, publishedName),
             let .detectImageWithNoStore(projectId, publishedName):
            return !projectId.isEmpty && !publishedName.isEmpty
        }
    }
}

enum TrainingApi: CustomVisionApi {
    
    case createImageRegions(projectId: String)
    case deleteImageRegions(projectId: String)
    case createImagesFromData(projectId: String)
    case deleteImages(projectId: String)
    case createImagesFromFiles(projectId: String)
    case createImagesFromPredictions(projectId: String)
    case createImagesFromUrls(projectId: String)
    case createImageTags(projectId: String)
    case deleteImageTags(projectId: String)
    case createProject
    case getProjects
    case createTag(projectId: String)
    case getTags(projectId: String)
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
    case getDomain(domainId: String)
    case getDomains
    case getImagePerformanceCount(projectId: String, iterationId: String)
    case getImagePerformances(projectId: String, iterationId: String)
    case getImageRegionProposals(projectId: String, imageId: String)
    case getImagesById(projectId: String)
    case getIterationPerformance(projectId: String, iterationId: String)
    case getIterations(projectId: String)
    case getTaggedImageCount(projectId: String)
    case getTaggedImages(projectId: String)
    case getUntaggedImageCount(projectId: String)
    case getUntaggedImages(projectId: String)
    case publishIteration(projectId: String, iterationId: String)
    case unpublishIteration(projectId: String, iterationId: String)
    case queryPredictions(projectId: String)
    case quickTestImage(projectId: String)
    case quickTestImageUrl(projectId: String)
    case trainProject(projectId: String)
    //case getAccountInfo
    
    static var name: String = "Training"
    static var version: String = "v3.0"
    static var service: String = "customvision"
    static var headerKey: String = "Training-key"

    static var subscriptionRegion: AzureRegion = .southCentralUS
    
    
    func contentType(_ boundary: String? = nil) -> String {
        switch self {
        case .createImagesFromData: return "multipart/form-data; boundary=\(boundary!)"
        default: return "application/json"
        }
    }
    
    func headerValue(trainingKey: String, predictionKey: String) throws -> String {
        guard !trainingKey.isEmpty else { throw CustomVisionClientError.noTrainingKey }
        return trainingKey
    }

    var path: String {
        switch self {
        case let .createImageRegions(projectId),
             let .deleteImageRegions(projectId):                    return "projects/\(projectId)/images/regions"
        case let .createImagesFromData(projectId),
             let .deleteImages(projectId):                          return "projects/\(projectId)/images"
        case let .createImagesFromFiles(projectId):                 return "projects/\(projectId)/images/files"
        case let .createImagesFromPredictions(projectId):           return "projects/\(projectId)/images/predictions"
        case let .createImagesFromUrls(projectId):                  return "projects/\(projectId)/images/urls"
        case .createProject, .getProjects:                          return "projects"
        case let .createTag(projectId),
             let .getTags(projectId):                               return "projects/\(projectId)/tags"
        case let .deleteImageTags(projectId),
             let .createImageTags(projectId):                       return "projects/\(projectId)/images/tags"
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
//        case .getAccountInfo:                                       return "account"
        case let .getDomain(domainId):                              return "domains/\(domainId)"
        case .getDomains:                                           return "domains"
        case let .getImagePerformanceCount(projectId, iterationId): return "projects/\(projectId)/iterations/\(iterationId)/performance/images/count"
        case let .getImagePerformances(projectId, iterationId):     return "projects/\(projectId)/iterations/\(iterationId)/performance/images"
        case let .getImageRegionProposals(projectId, imageId):      return "projects/\(projectId)/images/\(imageId)/regionproposals"
        case let .getImagesById(projectId):                         return "projects/\(projectId)/images/id"
        case let .getIterationPerformance(projectId, iterationId):  return "projects/\(projectId)/iterations/\(iterationId)/performance"
        case let .getIterations(projectId):                         return "projects/\(projectId)/iterations"
            case let .getTaggedImageCount(projectId):               return "projects/\(projectId)/images/tagged/count"
        case let .getTaggedImages(projectId):                       return "projects/\(projectId)/images/tagged"
            case let .getUntaggedImageCount(projectId):             return "projects/\(projectId)/images/untagged/count"
        case let .getUntaggedImages(projectId):                     return "projects/\(projectId)/images/untagged"
        case let .publishIteration(projectId, iterationId),
             let .unpublishIteration(projectId, iterationId):       return "projects/\(projectId)/iterations/\(iterationId)/publish"
        case let .queryPredictions(projectId):                      return "projects/\(projectId)/predictions/query"
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
//             .getAccountInfo,
             .getDomain,
             .getDomains,
             .getImagePerformanceCount,
             .getImagePerformances,
             .getImagesById,
             .getIterationPerformance,
             .getIterations,
             .getTaggedImageCount,
             .getTaggedImages,
             .getUntaggedImageCount,
             .getUntaggedImages:
            return .get
        case .createImageRegions,
             .createImagesFromData,
             .createImagesFromFiles,
             .createImagesFromPredictions,
             .createImagesFromUrls,
             .createImageTags,
             .createProject,
             .createTag,
             .exportIteration,
             .getImageRegionProposals,
             .publishIteration,
             .queryPredictions,
             .quickTestImage,
             .quickTestImageUrl,
             .trainProject:
            return .post
        case .deleteImageRegions,
             .deleteImages,
             .deleteImageTags,
             .deleteIteration,
             .deletePrediction,
             .deleteProject,
             .deleteTag,
             .unpublishIteration:
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
             let .createImageTags(projectId),
             let .deletePrediction(projectId),
             let .deleteProject(projectId),
             let .getProject(projectId),
             let .updateProject(projectId),
             let .getIterations(projectId),
             let .getTaggedImages(projectId),
             let .getUntaggedImages(projectId),
             let .queryPredictions(projectId),
             let .quickTestImage(projectId),
             let .quickTestImageUrl(projectId),
             let .trainProject(projectId),
             let .createImageRegions(projectId),
             let .deleteImageRegions(projectId),
             let .getImagesById(projectId),
             let .getTaggedImageCount(projectId),
             let .getUntaggedImageCount(projectId):
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
             let .getIterationPerformance(projectId, iterationId),
             let .getImagePerformanceCount(projectId, iterationId),
             let .getImagePerformances(projectId, iterationId),
             let .publishIteration(projectId, iterationId),
             let .unpublishIteration(projectId, iterationId):
            return !projectId.isEmpty && !iterationId.isEmpty
        case let .getDomain(domainId):
            return !domainId.isEmpty
        case let .getImageRegionProposals(projectId, imageId):
            return !projectId.isEmpty && !imageId.isEmpty
        case .getDomains,
//             .getAccountInfo,
             .createProject,
             .getProjects:
            return true
        }
    }
}

public enum AzureRegion : String {
    case westUS2        = "westus2"
    case eastUS         = "eastus"
    case eastUS2        = "eastus2"
    case southCentralUS = "southcentralus"
    case westEurope     = "westeurope"
    case northEurope    = "northeurope"
    case southeastAsia  = "southeastasia"
    case australiaEast  = "australiaeast"
    case centralIndia   = "centralindia"
    case ukSouth        = "uksouth"
    case japanEast      = "japaneast"
    case northCentralUS = "northcentralus"
    
    var host: String {
        return self.rawValue + ".api.cognitive.microsoft.com"
    }
}
