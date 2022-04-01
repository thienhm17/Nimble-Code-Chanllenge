//
//  SurveyServices.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 4/1/22.
//

protocol SurveyServicesProtocol {
    func getSurveys(pageIndex: Int, pageSize: Int, completion: ((Result<GetSurveyResponse, APIError>)->())?)
}

final class SurveyServices: SurveyServicesProtocol {
    
    func getSurveys(pageIndex: Int, pageSize: Int, completion: ((Result<GetSurveyResponse, APIError>)->())?) {
        
        APIService.shared.request(endpoint: .getSurveys(pageIndex: pageIndex, pageSize: pageSize), completion: completion)
    }
}
