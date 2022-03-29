//
//  APIService.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/26/22.
//

import Foundation
import Alamofire

typealias CompletionHandler<T: Decodable> = ((Result<T, APIError>) -> Void)

class APIService {
    
    static let shared = APIService()
    
    private let numberOfRetry = 3
    
    private func request<T: Decodable>(endpoint: EndpointType,
                                       onQueue queue: DispatchQueue? = nil,
                                       completion: CompletionHandler<T>?) {
        
        AF.request(endpoint.request, interceptor: self)
            // validate request
            .validate()
            // handle response
            .responseData(queue: queue ?? .main) { (response) in
                
                switch response.result {
                case .success(let data):
                    do {
                        // return success if can decode to specified object
                        let jsonData = try JSONDecoder().decode(T.self, from: data)
                        completion?(.success(jsonData))
                    }
                    catch {
                        // return error decodable
                        completion?(.failure(APIError.responseSerializationFailed))
                    }
                    
                case .failure(let error):
                    // if has error data response
                    if let responseData = response.data {
                        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: responseData) {
                            completion?(.failure(APIError.errorResponse(errorResponse)))
                        
                        } else if let errorResponse = (try? JSONSerialization.jsonObject(with: responseData, options: [])) as? [String:Any] {
                            completion?(.failure(APIError.unknown(data: errorResponse)))
                        }
                    
                    // else return other error
                    } else if let responseCode = response.response?.statusCode {
                        completion?(.failure(APIError.specifiedCode(responseCode)))
                        
                    // else return other error
                    } else {
                        completion?(.failure(APIError.other(error)))
                    }
                }
            }
    }
    
}

extension APIService: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        // add Authorization to header
        var request = urlRequest
        guard let accessToken = UserDefaultsManager.shared.accessToken else {
            completion(.success(urlRequest))
            return
        }
        let bearerToken = "Bearer \(accessToken)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // check retry count
        guard request.retryCount < numberOfRetry else {
            completion(.doNotRetry)
            return
        }
        
        // check if need refresh token
        if request.response?.statusCode == 401 {
            APIService.shared.refreshToken { isSuccess in
                completion(isSuccess ? .retry : .doNotRetryWithError(APIError.unauthorized))
            }
        
        // else retry request
        } else {
            completion(.retry)
        }
    }
}

// MARK: Services
extension APIService {
    
    func login(email: String, password: String, completion: ((APIError?)->())?) {
        request(endpoint: .login(email: email, password: password)) { (result: Result<LoginResponse, APIError>) in
            
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
    
    func refreshToken(completion: ((Bool)->())?) {
        guard let refreshToken = UserDefaultsManager.shared.refreshToken else { return }
        
        request(endpoint: .refreshToken(token: refreshToken)) { (result: Result<LoginResponse, APIError>) in
            
            switch result {
            case .success(let response):
                if let accessToken = response.data?.attributes?.accessToken,
                   let refreshToken = response.data?.attributes?.refreshToken {
                    // store tokens
                    UserDefaultsManager.shared.accessToken = accessToken
                    UserDefaultsManager.shared.refreshToken = refreshToken
                    // callback completion
                    completion?(true)
                 
                } else {
                    completion?(false)
                }
            case .failure:
                completion?(false)
            }
        }
    }
    
    func getSurveys(pageIndex: Int, pageSize: Int, completion: ((Result<GetSurveyResponse, APIError>)->())?) {
        
        request(endpoint: .getSurveys(pageIndex: pageIndex, pageSize: pageSize), completion: completion)
    }
}
