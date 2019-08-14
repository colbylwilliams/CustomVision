//
//  CustomVisionResponse.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/14/18.
//

import Foundation

public struct CustomVisionResponse<T> {
    
    public let data: Data?
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let result: Result<T, Error>
    
    public init(request: URLRequest?, data: Data?, response: HTTPURLResponse?, result: Result<T, Error>) {
        self.request = request
        self.data = data
        self.response = response
        self.result = result
    }
    
    public init (_ resource: T) {
        self.init(request: nil, data: nil, response: nil, result: .success(resource))
    }
    
    public init (_ error: Error) {
        self.init(request: nil, data: nil, response: nil, result: .failure(error))
    }
}


public extension CustomVisionResponse {
    
    func printResponseData() {
        if let data = self.data {
            print("::::: Data :::::\n\(String(data: data, encoding: .utf8) ?? "fail")")
        } else {
            print("::::: Data :::::\nnil")
        }
    }
    func printResult() {
        switch self.result {
        case let .success(resource): print("::::: ✅ Success :::::")
        if let resources = resource as? [CustomStringConvertible] {
            for r in resources { print(r) }
        } else {
            print(resource)
        }
        case let .failure(error): print("::::: ❌ Failure :::::\n\(error)")
        }
    }
}
