//
//  SurveyQuestionResponse.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

struct QuestionNetworkModel: Codable {

    let id: Int?
    let question: String?

    enum CodingKeys: String, CodingKey {
        case id
        case question
    }
}
