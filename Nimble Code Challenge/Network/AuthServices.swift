//
//  AuthServices.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 4/1/22.
//

import Foundation

protocol AuthServicesProtocol {
    func login(email: String, password: String, completion: ((APIError?)->())?)
}

final class AuthServices: AuthServicesProtocol {
    
    func login(email: String, password: String, completion: ((APIError?) -> ())?) {
        APIService.shared.request(endpoint: .login(email: email, password: password)) { (result: Result<LoginResponse, APIError>) in
            
            switch result {
            case .success(let response):
                if let accessToken = response.data?.attributes?.accessToken,
                   let refreshToken = response.data?.attributes?.refreshToken {
                    // store tokens
                    UserDefaultsManager.shared.accessToken = accessToken
                    UserDefaultsManager.shared.refreshToken = refreshToken
                    // callback completion
                    completion?(nil)
                 
                } else {
                    completion?(APIError.unknown(data: nil))
                }
                
            case .failure(let error):
                completion?(error)
            }
        }
    }
}
