//
//  UtilityExtensions.swift
//  CustomVision
//
//  Created by Colby L Williams on 4/27/18.
//

import Foundation

extension String {
    
    func ensuringSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return self
        }
        return self + suffix
    }
    
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
}


extension Bundle {
    func plist(named name: String) -> Data? {
        if let url = self.url(forResource: name.removingSuffix(".plist"), withExtension: "plist") {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}


extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
