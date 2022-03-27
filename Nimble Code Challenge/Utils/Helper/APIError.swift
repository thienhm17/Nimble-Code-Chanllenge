//
//  APIError.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import Foundation

enum APIError: Error {
    case invalidUrl
    case specifiedCode(Int)
    case responseSerializationFailed
    case unauthorized
    case unknown(data: Any?)
    case other(Error)
    
    var errorMessage: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .specifiedCode(let code):
            return "Error code: \(code)"
        case .responseSerializationFailed:
            return "Serialization Failed"
        case .unauthorized:
            return "Unauthorized"
        case .unknown:
            return "Unexpected Error, Please try again!"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    static func map(_ error: Error) -> APIError {
        return (error as? APIError) ?? .other(error)
    }
}
