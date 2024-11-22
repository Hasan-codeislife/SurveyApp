//
//  SurveyService.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

protocol SurveyServiceProtocol: Sendable {
    func getQuestions() async throws -> [Question]
    func submitAnswer(_ id: Int, _ answer: String) async throws -> Bool
}

final class SurveyService: SurveyServiceProtocol {
    
    private let apiManager: ApiManagerProtocol
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getQuestions() async throws -> [Question] {
        let endpoint = SurveyEndPoint.getSurveyQuestions
        do {
            let response: [QuestionNetworkModel] = try await apiManager.makeNetworkCall(router: endpoint)
            var questions = [Question]()
            response.forEach { item in
                if let currentModel = Question.init(item: item) {
                    questions.append(currentModel)
                }
            }
            return questions
        } catch let error {
            throw error
        }
    }
    
    func submitAnswer(_ id: Int, _ answer: String) async -> Bool {
        let endpoint = SurveyEndPoint.postSurveyQuestion(id: id, answer: answer)
        return await apiManager.makeNetworkCallWithoutResponse(router: endpoint)
    }
}

// Using Factory to initialize the Service
extension SurveyService {
    static func create() -> SurveyService {
        return SurveyService(apiManager: ApiManager(client: APIClientURLSession()))
    }
}
