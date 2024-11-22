//
//  InitialScreenReducer.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import ComposableArchitecture

class InitialScreenReducer: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var errorMessage: String? = nil
        var shouldStartSurvey: Bool = false
        var questions: [Question]? = nil
    }
    
    @CasePathable
    enum Action {
        case fetchQuestions
        case fetchQuestionsResponse(Result<[Question], MyError>)
        case startSurvey
        case surveyDismiss
    }
    
    private var service: SurveyServiceProtocol
    
    init(service: SurveyServiceProtocol) {
        self.service = service
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchQuestions:
            return fetchQuestions(&state)
            
        case .fetchQuestionsResponse(let result):
            return handleFetchQuestionsResponse(result, &state)
            
        case .startSurvey:
            return startSurvey(&state)
            
        case .surveyDismiss:
            return surveyDismiss(&state)
        }
    }
    
    // MARK: - Helper Methods
    
    // Handling fetchQuestions action
    private func fetchQuestions(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { send in
            do {
                let questions = try await self.service.getQuestions()
                await send(.fetchQuestionsResponse(.success(questions)))
            } catch let error {
                await send(.fetchQuestionsResponse(.failure(MyError(error))))
            }
        }
    }
    
    // Handling response of fetched questions
    private func handleFetchQuestionsResponse(_ result: Result<[Question], MyError>, _ state: inout State) -> Effect<Action> {
        state.isLoading = false
        switch result {
        case .success(let questions):
            state.questions = questions
            return .send(.startSurvey)
        case .failure(let error):
            state.errorMessage = error.localizedDescription
            return .none
        }
    }
    
    // Starting the survey
    private func startSurvey(_ state: inout State) -> Effect<Action> {
        state.shouldStartSurvey = true
        return .none
    }
    
    // Dismissing the survey
    private func surveyDismiss(_ state: inout State) -> Effect<Action> {
        state.shouldStartSurvey = false
        return .none
    }
}
