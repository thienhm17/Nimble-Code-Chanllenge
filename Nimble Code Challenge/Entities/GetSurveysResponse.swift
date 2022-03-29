//
//  GetSurveysResponse.swift
//  Nimble Code Challenge
//
//  Created by Thien Huynh on 3/29/22.
//

import Foundation

struct GetSurveyResponse: Codable {
    let data: [Survey]?
    let meta: Meta?
}

// MARK: - Survey
struct Survey: Codable {
    let id: String
    let type: String?
    let attributes: SurveyAttribute?
}

// MARK: - SurveyAttribute
struct SurveyAttribute: Codable {
    let title, attributesDescription, thankEmailAboveThreshold, thankEmailBelowThreshold: String?
    let isActive: Bool?
    let coverImageURL: String?
    let createdAt, activeAt: String?
    let inactiveAt: String?
    let surveyType: String?

    enum CodingKeys: String, CodingKey {
        case title
        case attributesDescription = "description"
        case thankEmailAboveThreshold = "thank_email_above_threshold"
        case thankEmailBelowThreshold = "thank_email_below_threshold"
        case isActive = "is_active"
        case coverImageURL = "cover_image_url"
        case createdAt = "created_at"
        case activeAt = "active_at"
        case inactiveAt = "inactive_at"
        case surveyType = "survey_type"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let page, pages, pageSize, records: Int

    enum CodingKeys: String, CodingKey {
        case page, pages
        case pageSize = "page_size"
        case records
    }
}
