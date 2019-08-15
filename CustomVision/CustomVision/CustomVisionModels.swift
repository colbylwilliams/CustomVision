//
//  CustomVisionModels.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/14/18.
//

import Foundation

public struct CustomVisionErrorMessage : Codable {
    public let code: String
    public let message: String
}


// MARK: - Training API

public struct ApiKeys: Codable {
    public let trainingKeys: KeyPair?
    public let predictionKeys: KeyPair?    
}

public struct KeyPair: Codable {
    public let primaryKey: String?
    public let secondaryKey: String?
}

public struct Account: Codable {
    public let userName: String?
    public let email: String?
    public let keys: ApiKeys?
    public let quotas: AccountQuota?
}

public struct AccountQuota: Codable {
    public let tier: String?
    public let projects: Quota?
    public let predictions: Quota?
    public let perProject: [PerProjectQuota]?
}

public struct Quota: Codable {
    public let total: Int
    public let used: Int
    public let timeUntilReset: String?
}

public struct PerProjectQuota: Codable {
    public let projectId: String
    public let iterations: Quota?
    public let images: Quota?
    public let tags: Quota?
}

public struct Domain: Codable {
    public let id: String
    public let name: String?
    public let type: DomainType
    public let exportable: Bool
    public let enabled: Bool
}

public struct ImageTagCreateBatch: Codable {
    public let tags: [ImageTagCreateEntry]?
}

public struct ImageTagCreateEntry: Codable {
    public let imageId: String
    public let tagId: String
}

public struct ImageTagCreateSummary: Codable {
    public let created: [ImageTagCreateEntry]?
    public let duplicated: [ImageTagCreateEntry]?
    public let exceeded: [ImageTagCreateEntry]?
}

public struct ImageRegionCreateBatch: Codable {
    public let regions: [ImageRegionCreateEntry]?
}

public struct ImageRegionCreateEntry: Codable {
    public let imageId: String
    public let tagId: String
    public let left: Float
    public let top: Float
    public let width: Float
    public let height: Float
}

public struct ImageRegionCreateSummary: Codable {
    public let created: [ImageRegionCreateEntry]?
    public let duplicated: [ImageRegionCreateEntry]?
    public let exceeded: [ImageRegionCreateEntry]?
}

public struct ImageRegionCreateResult: Codable {
    public let imageId: String
    public let regionId: String
    public let tagName: String
    public let created: Date
    public let tagId: String
    public let left: Float
    public let top: Float
    public let width: Float
    public let height: Float
}

public struct Image: Codable {
    public let id: String
    public let created: Date
    public let width: Int
    public let height: Int
    public let resizedImageUri: URL?
    public let thumbnailUri: URL?
    public let originalImageUri: URL?
    public let tags: [ImageTag]?
    public let regions: [ImageRegion]?
}

public struct ImageTag: Codable {
    public let tagId: String
    public let tagName: String
    public let created: Date
}

public struct ImageRegion: Codable {
    public let regionId: String?
    public let tagName: String?
    public let created: Date?
    public let tagId: String
    public let left: Float
    public let top: Float
    public let width: Float
    public let height: Float
}

public struct PredictionTag: Codable {
    public let tagId: String
    public let tag: String?
    public let probability: Float
}

public struct ImageCreateSummary: Codable {
    public let isBatchSuccessful: Bool
    public let images: [ImageCreateResult]?
}

public struct ImageCreateResult: Codable {
    public let sourceUrl: String?
    public let status: ImageCreateStatus
    public let image: Image?
}

public struct ImageFileCreateBatch: Codable {
    public let images: [ImageFileCreateEntry]?
    public let tagIds: [String]?
}

public struct ImageFileCreateEntry: Codable {
    public let name: String?
    public let contents: Data?
    public let tagIds: [String]?
    public let regions: [Region]?
}

public struct Region: Codable {
    public let tagId: String
    public let left: Float
    public let top: Float
    public let width: Float
    public let height: Float
}

public struct ImageUrlCreateBatch: Codable {
    public let images: [ImageUrlCreateEntry]?
    public let tagIds: [String]?
}

public struct ImageUrlCreateEntry: Codable {
    public let url: URL
    public let tagIds: [String]?
    public let regions: [Region]?
}

public struct ImageIdCreateBatch: Codable {
    public let images: [ImageIdCreateEntry]?
    public let tagIds: [String]?
}

public struct ImageIdCreateEntry: Codable {
    public let id: String?
    public let tagIds: [String]?
    public let regions: [Region]?
}

public struct ImageRegionProposal: Codable {
    public let projectId: String
    public let imageId: String
    public let proposals: [RegionProposal]?
}

public struct RegionProposal: Codable {
    public let confidence: Float
    public let boundingBox: BoundingBox
}

public struct BoundingBox: Codable {
    public let left: Float
    public let top: Float
    public let width: Float
    public let height: Float
}

public struct ImageUrl: Codable {
    public let url: URL
}

public struct ImagePrediction: Codable {
    public let id: String
    public let project: String
    public let iteration: String
    public let created: Date
    public let predictions: [Prediction]?
}

public struct Prediction: Codable {
    public let probability: Float
    public let tagId: String
    public let tagName: String
    public let boundingBox: BoundingBox
}

public struct PredictionQueryToken: Codable {
    public let session: String?
    public let continuation: String?
    public let maxCount: Int
    public let orderBy: OrderBy
    public let tags: [PredictionQueryTag]?
    public let iterationId: String?
    public let startTime: Date?
    public let endTime: Date?
    public let application: String?
    
    public enum OrderBy: String, Codable {
        case newest     = "Newest"
        case oldest     = "Oldest"
        case suggested  = "Suggested"
    }
}

public struct PredictionQueryTag: Codable {
    public let id: String
    public let minThreshold: Float
    public let maxThreshold: Float
}

public struct PredictionQueryResult: Codable {
    public let token: PredictionQueryToken?
    public let results: [StoredImagePrediction]?
}

public struct StoredImagePrediction: Codable {
    public let resizedImageUri: URL?
    public let thumbnailUri: URL?
    public let originalImageUri: URL?
    public let domain: String
    public let id: String
    public let project: String
    public let iteration: String
    public let created: Date
    public let predictions: [Prediction]?
}

public struct IterationPerformance: Codable {
    public let perTagPerformance: [TagPerformance]?
    public let precision: Float
    public let precisionStdDeviation: Float
    public let recall: Float
    public let recallStdDeviation: Float
    public let averagePrecision: Float
}

public struct TagPerformance: Codable {
    public let id: String
    public let name: String?
    public let precision: Float
    public let precisionStdDeviation: Float
    public let recall: Float
    public let recallStdDeviation: Float
    public let averagePrecision: Float
}

public struct ImagePerformance: Codable {
    public let predictions: [Prediction]?
    public let id: String
    public let created: Date
    public let width: Float
    public let height: Float
    public let imageUri: String
    public let thumbnailUri: String
    public let tags: [ImageTag]?
    public let regions: [ImageRegion]?
}

public struct Project: Codable {
    public let id: String
    public let name: String
    public let description: String
    public let settings: ProjectSettings
    public let created: Date
    public let lastModified: Date
    public let thumbnailUri: URL?
    public let drModeEnabled: Bool
}

public struct ProjectSettings: Codable {
    public let domainId: String?
    public let classificationType: Classifier
    public let targetExportPlatforms: [ExportPlatform]
}

public struct Iteration: Codable {
    public let id: String
    public let name: String?
    public let isDefault: Bool
    public let status: String?
    public let created: Date
    public let lastModified: Date
    public let trainedAt: Date?
    public let projectId: String
    public let exportable: Bool
    public let exportableTo: [ExportPlatform]
    public let domainId: String?
    public let classificationType: Classifier
    public let trainingType: TrainingType
    public let reservedBudgetInHours: Int
    public let publishName: String
    public let originalPublishResourceId: String
}

public struct Export: Codable {
    public let platform: ExportPlatform
    public let status: ExportStatus
    public let downloadUri: URL?
    public let flavor: ExportFlavor
    public let newerVersionAvailable: Bool
}

public struct Tag: Codable {
    public let id: String
    public let name: String
    public let description: String
    public let type: TagType
    public let imageCount: Int
}

public struct CustomVisionError: Codable {
    public let code: CustomVisionErrorCode
    public let message: String
}


// MARK: enums

public enum DomainType: String, Codable {
    case classification  = "Classification"
    case objectDetection = "ObjectDetection"
}

public enum ImageCreateStatus: String, Codable {
    case ok = "OK"
    case okDuplicate = "OKDuplicate"
    case errorSource = "ErrorSource"
    case errorImageFormat = "ErrorImageFormat"
    case errorImageSize = "ErrorImageSize"
    case errorStorage = "ErrorStorage"
    case errorLimitExceed = "ErrorLimitExceed"
    case errorTagLimitExceed = "ErrorTagLimitExceed"
    case errorRegionLimitExceed = "ErrorRegionLimitExceed"
    case errorUnknown = "ErrorUnknown"
    case errorNegativeAndRegularTagOnSameImage = "ErrorNegativeAndRegularTagOnSameImage"
}

public enum Classifier: String, Codable {
    case multiclass = "Multiclass"
    case multilabel = "Multilabel"
}

public enum TrainingType: String, Codable {
    case regular    = "Regular"
    case advanced   = "Advanced"
}

public enum ExportPlatform: String, Codable {
    case coreML     = "CoreML"
    case tensorFlow = "TensorFlow"
    case DockerFile = "DockerFile"
    case onnx       = "ONNX"
    case valdk      = "VAIDK"
}

public enum ExportStatus: String, Codable {
    case exporting  = "Exporting"
    case failed     = "Failed"
    case done       = "Done"
}

public enum ExportFlavor: String, Codable {
    case linux      = "Linux"
    case windows    = "Windows"
    case onnx10     = "ONNX10"
    case onnx12     = "ONNX12"
    case arm        = "ARM"
}

public enum TagType: String, Codable {
    case regular    = "Regular"
    case negative   = "Negative"
}

public enum OrderBy: String, Codable {
    case newest     = "Newest"
    case oldest     = "Oldest"
}

public enum CustomVisionErrorCode: String, Codable {
    case noError = "NoError"
    case badRequest = "BadRequest"
    case badRequestExceededBatchSize = "BadRequestExceededBatchSize"
    case badRequestNotSupported = "BadRequestNotSupported"
    case badRequestInvalidIds = "BadRequestInvalidIds"
    case badRequestProjectName = "BadRequestProjectName"
    case badRequestProjectNameNotUnique = "BadRequestProjectNameNotUnique"
    case badRequestProjectDescription = "BadRequestProjectDescription"
    case badRequestProjectUnknownDomain = "BadRequestProjectUnknownDomain"
    case badRequestProjectUnknownClassification = "BadRequestProjectUnknownClassification"
    case badRequestProjectUnsupportedDomainTypeChange = "BadRequestProjectUnsupportedDomainTypeChange"
    case badRequestProjectUnsupportedExportPlatform = "BadRequestProjectUnsupportedExportPlatform"
    case badRequestIterationName = "BadRequestIterationName"
    case badRequestIterationNameNotUnique = "BadRequestIterationNameNotUnique"
    case badRequestIterationDescription = "BadRequestIterationDescription"
    case badRequestIterationIsNotTrained = "BadRequestIterationIsNotTrained"
    case badRequestWorkspaceCannotBeModified = "BadRequestWorkspaceCannotBeModified"
    case badRequestWorkspaceNotDeletable = "BadRequestWorkspaceNotDeletable"
    case badRequestTagName = "BadRequestTagName"
    case badRequestTagNameNotUnique = "BadRequestTagNameNotUnique"
    case badRequestTagDescription = "BadRequestTagDescription"
    case badRequestTagType = "BadRequestTagType"
    case badRequestMultipleNegativeTag = "BadRequestMultipleNegativeTag"
    case badRequestImageTags = "BadRequestImageTags"
    case badRequestImageRegions = "BadRequestImageRegions"
    case badRequestNegativeAndRegularTagOnSameImage = "BadRequestNegativeAndRegularTagOnSameImage"
    case badRequestRequiredParamIsNull = "BadRequestRequiredParamIsNull"
    case badRequestIterationIsPublished = "BadRequestIterationIsPublished"
    case badRequestInvalidPublishName = "BadRequestInvalidPublishName"
    case badRequestInvalidPublishTarget = "BadRequestInvalidPublishTarget"
    case badRequestUnpublishFailed = "BadRequestUnpublishFailed"
    case badRequestIterationNotPublished = "BadRequestIterationNotPublished"
    case badRequestSubscriptionApi = "BadRequestSubscriptionApi"
    case badRequestExceedProjectLimit = "BadRequestExceedProjectLimit"
    case badRequestExceedIterationPerProjectLimit = "BadRequestExceedIterationPerProjectLimit"
    case badRequestExceedTagPerProjectLimit = "BadRequestExceedTagPerProjectLimit"
    case badRequestExceedTagPerImageLimit = "BadRequestExceedTagPerImageLimit"
    case badRequestExceededQuota = "BadRequestExceededQuota"
    case badRequestCannotMigrateProjectWithName = "BadRequestCannotMigrateProjectWithName"
    case badRequestNotLimitedTrial = "BadRequestNotLimitedTrial"
    case badRequestImageBatch = "BadRequestImageBatch"
    case badRequestImageStream = "BadRequestImageStream"
    case badRequestImageUrl = "BadRequestImageUrl"
    case badRequestImageFormat = "BadRequestImageFormat"
    case badRequestImageSizeBytes = "BadRequestImageSizeBytes"
    case badRequestImageExceededCount = "BadRequestImageExceededCount"
    case badRequestTrainingNotNeeded = "BadRequestTrainingNotNeeded"
    case badRequestTrainingNotNeededButTrainingPipelineUpdated = "BadRequestTrainingNotNeededButTrainingPipelineUpdated"
    case badRequestTrainingValidationFailed = "BadRequestTrainingValidationFailed"
    case badRequestClassificationTrainingValidationFailed = "BadRequestClassificationTrainingValidationFailed"
    case badRequestMultiClassClassificationTrainingValidationFailed = "BadRequestMultiClassClassificationTrainingValidationFailed"
    case badRequestMultiLabelClassificationTrainingValidationFailed = "BadRequestMultiLabelClassificationTrainingValidationFailed"
    case badRequestDetectionTrainingValidationFailed = "BadRequestDetectionTrainingValidationFailed"
    case badRequestTrainingAlreadyInProgress = "BadRequestTrainingAlreadyInProgress"
    case badRequestDetectionTrainingNotAllowNegativeTag = "BadRequestDetectionTrainingNotAllowNegativeTag"
    case badRequestInvalidEmailAddress = "BadRequestInvalidEmailAddress"
    case badRequestDomainNotSupportedForAdvancedTraining = "BadRequestDomainNotSupportedForAdvancedTraining"
    case badRequestExportPlatformNotSupportedForAdvancedTraining = "BadRequestExportPlatformNotSupportedForAdvancedTraining"
    case badRequestReservedBudgetInHoursNotEnoughForAdvancedTraining = "BadRequestReservedBudgetInHoursNotEnoughForAdvancedTraining"
    case badRequestExportValidationFailed = "BadRequestExportValidationFailed"
    case badRequestExportAlreadyInProgress = "BadRequestExportAlreadyInProgress"
    case badRequestPredictionIdsMissing = "BadRequestPredictionIdsMissing"
    case badRequestPredictionIdsExceededCount = "BadRequestPredictionIdsExceededCount"
    case badRequestPredictionTagsExceededCount = "BadRequestPredictionTagsExceededCount"
    case badRequestPredictionResultsExceededCount = "BadRequestPredictionResultsExceededCount"
    case badRequestPredictionInvalidApplicationName = "BadRequestPredictionInvalidApplicationName"
    case badRequestPredictionInvalidQueryParameters = "BadRequestPredictionInvalidQueryParameters"
    case badRequestInvalid = "BadRequestInvalid"
    case unsupportedMediaType = "UnsupportedMediaType"
    case forbidden = "Forbidden"
    case forbiddenUser = "ForbiddenUser"
    case forbiddenUserResource = "ForbiddenUserResource"
    case forbiddenUserSignupDisabled = "ForbiddenUserSignupDisabled"
    case forbiddenUserSignupAllowanceExceeded = "ForbiddenUserSignupAllowanceExceeded"
    case forbiddenUserDoesNotExist = "ForbiddenUserDoesNotExist"
    case forbiddenUserDisabled = "ForbiddenUserDisabled"
    case forbiddenUserInsufficientCapability = "ForbiddenUserInsufficientCapability"
    case forbiddenDRModeEnabled = "ForbiddenDRModeEnabled"
    case forbiddenInvalid = "ForbiddenInvalid"
    case notFound = "NotFound"
    case notFoundProject = "NotFoundProject"
    case notFoundProjectDefaultIteration = "NotFoundProjectDefaultIteration"
    case notFoundIteration = "NotFoundIteration"
    case notFoundIterationPerformance = "NotFoundIterationPerformance"
    case notFoundTag = "NotFoundTag"
    case notFoundImage = "NotFoundImage"
    case notFoundDomain = "NotFoundDomain"
    case notFoundApimSubscription = "NotFoundApimSubscription"
    case notFoundInvalid = "NotFoundInvalid"
    case conflict = "Conflict"
    case conflictInvalid = "ConflictInvalid"
    case errorUnknown = "ErrorUnknown"
    case errorProjectInvalidWorkspace = "ErrorProjectInvalidWorkspace"
    case errorProjectInvalidPipelineConfiguration = "ErrorProjectInvalidPipelineConfiguration"
    case errorProjectInvalidDomain = "ErrorProjectInvalidDomain"
    case errorProjectTrainingRequestFailed = "ErrorProjectTrainingRequestFailed"
    case errorProjectExportRequestFailed = "ErrorProjectExportRequestFailed"
    case errorFeaturizationServiceUnavailable = "ErrorFeaturizationServiceUnavailable"
    case errorFeaturizationQueueTimeout = "ErrorFeaturizationQueueTimeout"
    case errorFeaturizationInvalidFeaturizer = "ErrorFeaturizationInvalidFeaturizer"
    case errorFeaturizationAugmentationUnavailable = "ErrorFeaturizationAugmentationUnavailable"
    case errorFeaturizationUnrecognizedJob = "ErrorFeaturizationUnrecognizedJob"
    case errorFeaturizationAugmentationError = "ErrorFeaturizationAugmentationError"
    case errorExporterInvalidPlatform = "ErrorExporterInvalidPlatform"
    case errorExporterInvalidFeaturizer = "ErrorExporterInvalidFeaturizer"
    case errorExporterInvalidClassifier = "ErrorExporterInvalidClassifier"
    case errorPredictionServiceUnavailable = "ErrorPredictionServiceUnavailable"
    case errorPredictionModelNotFound = "ErrorPredictionModelNotFound"
    case errorPredictionModelNotCached = "ErrorPredictionModelNotCached"
    case errorPrediction = "ErrorPrediction"
    case errorPredictionStorage = "ErrorPredictionStorage"
    case errorRegionProposal = "ErrorRegionProposal"
    case errorInvalid = "ErrorInvalid"
}


// MARK: Equatable

extension Domain: Equatable {
    public static func ==(lhs: Domain, rhs: Domain) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Image: Equatable {
    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.id == rhs.id
    }
}

extension ImageTag: Equatable {
    public static func ==(lhs: ImageTag, rhs: ImageTag) -> Bool {
        return lhs.tagId == rhs.tagId
    }
}

extension PredictionTag: Equatable {
    public static func ==(lhs: PredictionTag, rhs: PredictionTag) -> Bool {
        return lhs.tagId == rhs.tagId
    }
}

extension Prediction: Equatable {
    public static func ==(lhs: Prediction, rhs: Prediction) -> Bool {
        return lhs.tagId == rhs.tagId
    }
}

extension Project: Equatable {
    public static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Iteration: Equatable {
    public static func ==(lhs: Iteration, rhs: Iteration) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Tag: Equatable {
    public static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}
