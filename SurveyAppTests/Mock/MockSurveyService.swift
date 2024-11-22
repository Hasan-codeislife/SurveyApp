//
//  MockSurveyService.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import Foundation
@testable import SurveyApp

final class MockSurveyService: SurveyServiceProtocol, @unchecked Sendable {
    
    var shouldSucceed = true
    func getQuestions() throws -> [Question] {
        if shouldSucceed {
            return MockData.mockQuestions
        }
        throw MockData.error
    }
    
    func submitAnswer(_ id: Int, _ answer: String) async throws -> Bool {
        return shouldSucceed
    }
}
