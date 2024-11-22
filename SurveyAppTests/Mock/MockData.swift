//
//  MockData.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

@testable import SurveyApp
import Foundation

enum MockData {
    static let mockQuestions: [Question] = [
        Question(id: 0, question: "What is your favorite color?"),
        Question(id: 1, question: "How many continents are there on Earth?")
    ]
    static let error = MyError(NSError(domain: "", code: -1, userInfo: nil))
}
