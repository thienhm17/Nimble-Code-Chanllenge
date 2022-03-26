//
//  Encodable+Ext.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = data else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    func toJson() -> String? {
        if let jsonData = data {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}
