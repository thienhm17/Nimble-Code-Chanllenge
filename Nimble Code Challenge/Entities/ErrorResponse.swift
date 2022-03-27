//
//  ErrorResponse.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import Foundation

// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let errors: [ErrorDetail]?
}

// MARK: - Error
struct ErrorDetail: Codable {
    let source: Source?
    let detail, code: String?
}

// MARK: - Source
struct Source: Codable {
    let parameter: String?
}
