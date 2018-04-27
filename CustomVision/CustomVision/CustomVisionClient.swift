//
//  CustomVisionClient.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/14/18.
//

import Foundation

public class CustomVisionClient {
    
    let host = "southcentralus.api.cognitive.microsoft.com"
    let basePath = "/customvision/v1.2/Training"
    let scheme = "https://"
    
    
    public static let shared: CustomVisionClient = {
       
        let client = CustomVisionClient()
        
        client.getKeysFromPlist()
        
        return client
    }()
    
    
    static let iso8601Formatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        formatter.calendar      = Calendar(identifier: .iso8601)
        formatter.locale        = Locale(identifier: "en_US_POSIX")
        formatter.timeZone      = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return formatter
    }()
    
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(iso8601Formatter)
        return encoder
    }()
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(iso8601Formatter)
        return decoder
    }()
    
    
    let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    let pollDelay: Double = 3
    
    fileprivate
    var _modelName = "custom.mlmodel"
    public var modelName: String {
        get {
            return _modelName
        }
        set {
            if newValue.contains(".mlmodel") {
                _modelName = newValue
            } else {
                _modelName = newValue + ".mlmodel"
            }
        }
    }

    public var trainingKey: String = ""
    
    public static var defaultProjectId: String = ""
    
    public func getKeysFromPlist(customPlistName: String? = nil) {
        
        if let keys = CustomVisionKeys.tryCreateFromPlists(custom: customPlistName) {
            
            trainingKey = keys.trainingKey!
            
            if keys.hasValidProjectId {
                CustomVisionClient.defaultProjectId = keys.projectId!
            }
        }
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from data: Data, withTags tagIds: [String]? = nil, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> ()) {
        
        let query = getQuery(("tagIds", tagIds))
        
        do {
            let request = try dataRequest(for: .createImagesFromData(projectId: projectId), withBody: data, withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deleteImages(inProject projectId: String = defaultProjectId, withIds imageIds: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = getQuery(("imageIds", imageIds))
        
        do {
            let request = try dataRequest(for: .deleteImages(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageFileCreateBatch: ImageFileCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        do {
            let request = try dataRequest(for: .createImagesFromFiles(projectId: projectId), withBody: imageFileCreateBatch)
            
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageIdCreateBatch: ImageIdCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        do {
            let request = try dataRequest(for: .createImagesFromPredictions(projectId: projectId), withBody: imageIdCreateBatch)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
        
    }
    
    public func createImages(inProject projectId: String = defaultProjectId, from imageUrlCreateBatch: ImageUrlCreateBatch, completion: @escaping (CustomVisionResponse<ImageCreateSummary>) -> Void) {
        
        do {
            let request = try dataRequest(for: .createImagesFromUrls(projectId: projectId), withBody: imageUrlCreateBatch)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func createProject(withDescription description: String? = nil, inDomain domain: String? = nil, completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        let query = getQuery(("domainId", domain), ("description", description))

        do {
            let request = try dataRequest(for: .createProject, withBody: query)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getProjects(completion: @escaping (CustomVisionResponse<[Project]>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getProjects)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func createTag(inProject projectId: String = defaultProjectId, withName name: String, andDescription description: String? = nil, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        let query = getQuery(("name", name), ("description", description))
        
        do {
            let request = try dataRequest(for: .createTag(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getTags(inProject projectId: String = defaultProjectId, forIteration iteration: String? = nil, completion: @escaping (CustomVisionResponse<TagList>) -> Void) {
        
        let query = getQuery(("iterationId", iteration))
        
        do {
            let request = try dataRequest(for: TrainingApi.getTags(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deleteTags(inProject projectId: String = defaultProjectId, withTagIds tagIds: [String], from images: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = getQuery(("tagIds", tagIds), ("imageIds", images))
        
        do {
            let request = try dataRequest(for: .deleteImageTags(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func postImageTags(inProject projectId: String = defaultProjectId, with imageTagCreateBatch: ImageTagCreateBatch, completion: @escaping (CustomVisionResponse<ImageTagCreateSummary>) -> Void) {
        
        do {
            let request = try dataRequest(for: .postImageTags(projectId: projectId), withBody: imageTagCreateBatch)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deleteIteration(fromProject projectId: String = defaultProjectId, withId iterationId: String, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        do {
            let request = try dataRequest(for: .deleteIteration(projectId: projectId, iterationId: iterationId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getIteration(projectId: projectId, iterationId: iterationId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func updateIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, to iteration: Iteration, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        do {
            let request = try dataRequest(for: .updateIteration(projectId: projectId, iterationId: iterationId), withBody: iteration)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deletePrediction(fromProject projectId: String = defaultProjectId, withIds ids: [String], completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        let query = getQuery(("ids", ids))
        
        do {
            let request = try dataRequest(for: .deletePrediction(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deleteProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        CustomVisionClient.defaultProjectId = ""
        
        do {
            let request = try dataRequest(for: .deleteProject(projectId: projectId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getProject(projectId: projectId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func updateProject(withId projectId: String = defaultProjectId, to project: Project, completion: @escaping (CustomVisionResponse<Project>) -> Void) {
        
        do {
            let request = try dataRequest(for: .updateProject(projectId: projectId), withBody: project)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func deleteTag(fromProject projectId: String = defaultProjectId, withId tagId: String, completion: @escaping (CustomVisionResponse<Data>) -> Void) {
        
        do {
            let request = try dataRequest(for: .deleteTag(projectId: projectId, tagId: tagId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getTag(inProject projectId: String = defaultProjectId, withId tagId: String, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getTag(projectId: projectId, tagId: tagId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func updateTag(inProject projectId: String = defaultProjectId, withId tagId: String, to tag: Tag, completion: @escaping (CustomVisionResponse<Tag>) -> Void) {
        
        do {
            let request = try dataRequest(for: .updateTag(projectId: projectId, tagId: tagId), withBody: tag)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func exportIteration(inProject projectId: String = defaultProjectId, withId iterationId: String, forPlatform platform: Export.Platform, completion: @escaping (CustomVisionResponse<Export>) -> Void) {
        
        let query = getQuery(("platform", platform.rawValue))
        
        do {
            let request = try dataRequest(for: .exportIteration(projectId: projectId, iterationId: iterationId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getExports(fromIteration iterationId: String, inProject projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<[Export]>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getExports(projectId: projectId, iterationId: iterationId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getAccountInfo(completion: @escaping (CustomVisionResponse<Account>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getAccountInfo)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getDomain(withId domainId: String, completion: @escaping (CustomVisionResponse<Domain>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getDomain(domainId: domainId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getDomains(completion: @escaping (CustomVisionResponse<[Domain]>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getDomains)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getPerformance(forIteration iterationId: String, inProject projectId: String = defaultProjectId, withThreshold threshold: Float, completion: @escaping (CustomVisionResponse<IterationPerformance>) -> Void) {
        
        let query = getQuery(("threshold", threshold))
        
        do {
            let request = try dataRequest(for: .getIterationPerformance(projectId: projectId, iterationId: iterationId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getIterations(inProject projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<[Iteration]>) -> Void) {
        
        do {
            let request = try dataRequest(for: .getIterations(projectId: projectId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getTaggedImages(forIteration iterationId: String? = nil, inProject projectId: String = defaultProjectId, withTags tags: [String]? = nil, orderedBy orderBy: OrderBy? = nil, take: Int = 50, skip: Int = 0, completion: @escaping (CustomVisionResponse<[Image]>) -> Void) {
        
        let query = getQuery(("iterationId", iterationId), ("tagIds", tags), ("orderBy", orderBy?.rawValue), ("take", take), ("skip", skip))
        
        do {
            let request = try dataRequest(for: .getTaggedImages(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func getUntaggedImages(forIteration iterationId: String? = nil, inProject projectId: String = defaultProjectId, orderedBy orderBy: OrderBy? = nil, take: Int = 50, skip: Int = 0, completion: @escaping (CustomVisionResponse<[Image]>) -> Void) {
        
        let query = getQuery(("iterationId", iterationId), ("orderBy", orderBy?.rawValue), ("take", take), ("skip", skip))
        
        do {
            let request = try dataRequest(for: .getUntaggedImages(projectId: projectId), withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func queryPredictionResults(inProject projectId: String = defaultProjectId, with predictionQueryToken: PredictionQueryToken, completion: @escaping (CustomVisionResponse<PredictionQuery>) -> Void) {
        
        do {
            let request = try dataRequest(for: .queryPredictionResults(projectId: projectId), withBody: predictionQueryToken)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func quickTestImage(forIteration iterationId: String? = nil, inProject projectId: String = defaultProjectId, with imageData: Data, completion: @escaping (CustomVisionResponse<ImagePredictionResult>) -> Void) {
        
        let query = getQuery(("iterationId", iterationId))
        
        do {
            let request = try dataRequest(for: .quickTestImage(projectId: projectId), withBody: imageData, withQuery: query)
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func quickTestImageUrl(forIteration iterationId: String? = nil, inProject projectId: String = defaultProjectId, with imageUrl: ImageUrl, completion: @escaping (CustomVisionResponse<ImagePredictionResult>) -> Void) {
        
        let query = getQuery(("iterationId", iterationId))
        
        do {
            let request = try dataRequest(for: .quickTestImageUrl(projectId: projectId), withBody: imageUrl, withQuery: query)
        
            return sendRequest(request, completion: completion)

        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    public func trainProject(withId projectId: String = defaultProjectId, completion: @escaping (CustomVisionResponse<Iteration>) -> Void) {
        
        do {
            let request = try dataRequest(for: .trainProject(projectId: projectId))
        
            return sendRequest(request, completion: completion)
        
        } catch {
            completion(CustomVisionResponse(error))
        }
    }
    
    
    
    fileprivate func sendRequest<T:Codable> (_ request: URLRequest, completion: @escaping (CustomVisionResponse<T>) -> ()) {
        
        session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            
            if let error = error {
                
                completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .failure(error)))
                
            } else if let data = data {
                
                do {
                    
                    let resource = try self.decoder.decode(T.self, from: data)
                    
                    completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .success(resource)))
                    
                } catch {
                    
                    completion(CustomVisionResponse(request: request, data: data, response: httpResponse, result: .failure(error)))
                }
            } else {
                completion(CustomVisionResponse.init(request: request, data: data, response: httpResponse, result: .failure(CustomVisionClientError.unknown)))
            }
        }.resume()
    }
    
    fileprivate func dataRequest(for api: TrainingApi, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }
    
    fileprivate func dataRequest<T:Codable>(for api: TrainingApi, withBody body: T? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        if let body = body {
            
            let bodyData = try encoder.encode(body)
        
            return try self._dataRequest(for: api, withBody: bodyData, withQuery: query, andHeaders: headers)
        }
        
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }

    fileprivate func dataRequest(for api: TrainingApi, withBody body: Data? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        if let body = body {
            
            return try self._dataRequest(for: api, withBody: getMultipartFormBody(body), withQuery: query, andHeaders: headers)
        }
        
        return try self._dataRequest(for: api, withQuery: query, andHeaders: headers)
    }

    let boundary = "Boundary-\(UUID().uuidString)"
    
    fileprivate func _dataRequest(for api: TrainingApi, withBody body: Data? = nil, withQuery query: String? = nil, andHeaders headers: [String:String]? = nil) throws -> URLRequest {
        
        guard !trainingKey.isEmpty else { throw CustomVisionClientError.noTrainingKey }
        
        guard api.hasValidIds else { throw CustomVisionClientError.invalidIds }
        
        var urlString = scheme + host + basePath + api.path
        
        if let queryString = query, !queryString.isEmpty {
            urlString = urlString + queryString
        }

        print(urlString)
        
        guard let url = URL(string: urlString) else { throw CustomVisionClientError.urlError(urlString) }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = api.method.rawValue
        
        if case TrainingApi.createImagesFromData = api {
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.addValue(trainingKey, forHTTPHeaderField: "Training-key")
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        request.httpBody = body
        
        return request
    }
    
    fileprivate func getMultipartFormBody(_ data: Data) -> Data {
        
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(UUID().uuidString).jpeg\"\r\n")
        body.appendString("Content-Type: image/jpg\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body
    }
    
    fileprivate func getQuery(_ args: (String, Any?)...) -> String? {
        
        var query: String? = nil
        
        let filtered = args.compactMap { $0.1 != nil ? ($0.0, $0.1!) : nil }
        
        for item in filtered {
            query.add(item.0, item.1)
        }
        
        return query
    }
    
    public func getErrorMessage<T>(from response: CustomVisionResponse<T>, _ update: @escaping (String) -> Void, _ completion: @escaping (Bool, String) -> Void) {
        return getErrorMessage(from: response, completion)
    }
    
    public func getErrorMessage<T>(from response: CustomVisionResponse<T>, _ completion: @escaping (Bool, String) -> Void) {
        
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


fileprivate extension Optional where Wrapped == String {
    mutating func add (_ queryKey: String, _ queryValue: Any?) {
        if self == nil, let queryValue = queryValue {
            
            if let queryValueString = queryValue as? String, queryValueString.isEmpty {
                return
            }
            
            var queryValueString = "\(queryValue)"
            
            if let queryValueArray = queryValue as? [String], !queryValueArray.isEmpty {
                queryValueString = queryValueArray.joined(separator: ",").replacingOccurrences(of: "\\\"", with: "")
            }
            
            if !queryValueString.isEmpty {
                self = "?\(queryKey)=\(queryValueString)"
            }
        } else {
            self!.add(queryKey, queryValue)
        }
    }
}

fileprivate extension String {
    mutating func add (_ queryKey: String, _ queryValue: Any?) {
        if let queryValue = queryValue {
            
            if let queryValueString = queryValue as? String, queryValueString.isEmpty {
                return
            }

            var queryValueString = "\(queryValue)"
            
            if let queryValueArray = queryValue as? [String], !queryValueArray.isEmpty {
                queryValueString = queryValueArray.joined(separator: ",").replacingOccurrences(of: "\\\"", with: "")
            }

            if !queryValueString.isEmpty, self.contains("?") {
                self += "&\(queryKey)=\(queryValueString)"
            } else {
                self = "?\(queryKey)=\(queryValueString)"
            }
        }
    }
}

enum HttpMethod : String {
    case get    = "GET"
    case head   = "HEAD"
    case patch  = "PATCH"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    
    var lowercased: String {
        switch self {
        case .get:      return "get"
        case .head:     return "head"
        case .patch:    return "patch"
        case .post:     return "post"
        case .put:      return "put"
        case .delete:   return "delete"
        }
    }
    
    var read: Bool {
        switch self {
        case .get, .head:           return true
        case .patch, .post, .put, .delete:  return false
        }
    }
    
    var write: Bool {
        return !read
    }
}
