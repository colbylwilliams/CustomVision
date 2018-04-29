//
//  CustomVisionClientError.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/25/18.
//

import Foundation

public enum CustomVisionClientError : Error {
    case unknown
    case invalidIds
    case noTrainingKey
    case noPredictionKey
    case urlError(String)
    case decodeError(DecodingError)
    case encodingError(EncodingError)
}
