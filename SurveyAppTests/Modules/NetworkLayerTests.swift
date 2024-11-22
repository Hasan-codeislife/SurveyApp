//
//  NetworkLayerTests.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import Foundation
import Testing
@testable import SurveyApp

class NetworkLayerTests {
        
    @Test func jsonFileRetrieval() async {
        let testURLString = "https://xm-assignment.web.app/questions"
        let urlRequest = URLRequest(url: URL(string: testURLString)!)
        let mockAPIClient = MockAPIClient()
        let jsonFileName = mockAPIClient.getFileName(from: urlRequest)
        
        #expect(jsonFileName == "get_questions", "Expected to retrieve 'get_questions' as the JSON file name")

    }
    
    @Test func jsonParsing() async {
        let mockAPIClient = MockAPIClient()
        let service = SurveyService(apiManager: ApiManager(client: mockAPIClient))
        
        do {
            let questions = try await service.getQuestions()
            #expect(questions.count == 10, "Expected to retrieve 10 valid questions from JSON")
        } catch {
            #expect(Bool(false), "JSON parsing failed with error: \(error)")
        }
    }
}
