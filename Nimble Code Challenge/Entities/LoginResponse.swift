//
//  LoginResponse.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/27/22.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let data: LoginResult?
}

// MARK: - LoginResult
struct LoginResult: Codable {
    let id: String
    let type: String?
    let attributes: Token?
}

// MARK: - Token
struct Token: Codable {
    let tokenType: String?
    let accessToken: String?
    let expiresIn: Int?
    let refreshToken: String?
    let createdAt: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
    }
}
