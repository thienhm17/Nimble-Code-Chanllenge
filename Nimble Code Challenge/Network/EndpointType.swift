//
//  EndpointType.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import Foundation
import Alamofire

enum EndpointType {
    case login(email: String, password: String)
    case refreshToken(token: String)
    
    var request: EndpointRequest {
        switch self {
        
        case .login(let email, let password):
            return EndpointRequest(method: .post,
                                   path: "api/v1/oauth/token",
                                   body: ["grant_type": "password",
                                          "email": email,
                                          "password": password,
                                          "client_id": App.Configuration.clientId,
                                          "client_secret": App.Configuration.clientSecret])
            
        case .refreshToken(let token):
            return EndpointRequest(method: .post,
                                   path: "api/v1/oauth/token",
                                   body: ["grant_type": "refresh_token",
                                          "refresh_token": token,
                                          "client_id": App.Configuration.clientId,
                                          "client_secret": App.Configuration.clientSecret])
        }
    }
}

struct EndpointRequest: URLRequestConvertible {
    
    let method: HTTPMethod
    let baseUrl: String
    let path: String
    var headers: [String: String]?
    var queries: [String: Any]?
    var body: Any?
    
    init(method: HTTPMethod, baseUrl: String = App.Configuration.baseUrl, path: String, headers: [String: String]? = nil, queries: [String: Any]? = nil, body: Any? = nil) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.queries = queries
        self.body = body
    }
    
    func asURLRequest() throws -> URLRequest {
        
        // build URL
        guard let urlRequest = URL(string: baseUrl + path) else { throw APIError.invalidUrl }
        var request = URLRequest(url: urlRequest)
        
        // set method
        request.httpMethod = method.rawValue
        // build headers
        if let headers = self.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if method == .post || method == .put || method == .patch {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // build queries
        if let queries = self.queries {
            let queryParams = queries.map { pair  in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: urlRequest.absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
        }
        // build body
        if let body = self.body as? Encodable {
            request.httpBody = body.data
        
        } else if let body = self.body as? [String: Any] {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}
