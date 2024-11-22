//
//  Question.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

struct Question: Equatable, Identifiable {
    let id: Int
    let question: String
    var answer: String = ""
    var isSubmitted: Bool = false
    
    init(id: Int, question: String) {
        self.id = id
        self.question = question
    }
    
    init?(item: QuestionNetworkModel) {
        guard let id = item.id, let question = item.question else { return nil }
        self.id = id
        self.question = question
    }
}
