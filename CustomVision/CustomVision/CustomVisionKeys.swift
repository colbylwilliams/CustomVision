//
//  CustomVisionKeys.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/26/18.
//

import Foundation

struct CustomVisionKeys : Codable {
    
    fileprivate static let projectIdDefault     = "CUSTOM_VISION_PROJECT_ID"
    fileprivate static let trainingKeyDefault   = "CUSTOM_VISION_TRAINING_KEY"
    fileprivate static let predictionKeyDefault = "CUSTOM_VISION_PREDICTION_KEY"

    let projectId:   String?
    let trainingKey: String?
    let predictionKey: String?


    var hasValidProjectId: Bool {
        return projectId != nil && !projectId!.isEmpty && projectId! != CustomVisionKeys.projectIdDefault
    }

    var hasValidTrainingKey: Bool {
        return trainingKey != nil && !trainingKey!.isEmpty && trainingKey! != CustomVisionKeys.trainingKeyDefault
    }

    var hasValidPredictionKey: Bool {
        return predictionKey != nil && !predictionKey!.isEmpty && predictionKey! != CustomVisionKeys.predictionKeyDefault
    }

    
    init?(from infoDictionary: [String:Any]?) {
        guard let info = infoDictionary else { return nil }
        projectId     = info[CodingKeys.projectId.rawValue]     as? String
        trainingKey   = info[CodingKeys.trainingKey.rawValue]   as? String
        predictionKey = info[CodingKeys.predictionKey.rawValue] as? String
    }
    
    private enum CodingKeys: String, CodingKey {
        case projectId     = "CustomVisionProjectId"
        case trainingKey   = "CustomVisionTrainingKey"
        case predictionKey = "CustomVisionPredictionKey"
    }
    
    static func tryCreateFromPlists(custom: String? = nil) -> CustomVisionKeys? {
        
        let plistDecoder = PropertyListDecoder()
        
        if let customName = custom,
            let customData = Bundle.main.plist(named: customName),
            let customKeys = try? plistDecoder.decode(CustomVisionKeys.self, from: customData),
            (customKeys.hasValidTrainingKey || customKeys.hasValidPredictionKey) {
            
            return customKeys
        }
        
        if let visionData = Bundle.main.plist(named: "CustomVision"),
            let visionKeys = try? plistDecoder.decode(CustomVisionKeys.self, from: visionData),
            (visionKeys.hasValidTrainingKey || visionKeys.hasValidPredictionKey) {
            
            return visionKeys
        }
        
        if let infoKeys = CustomVisionKeys(from: Bundle.main.infoDictionary),
            (infoKeys.hasValidTrainingKey || infoKeys.hasValidPredictionKey) {
            
            return infoKeys
        }
        
        return nil
    }
}
