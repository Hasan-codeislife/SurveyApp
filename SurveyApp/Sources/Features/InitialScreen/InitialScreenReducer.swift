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
        var questions: IdentifiedArrayOf<Question>? = nil
    }
    
    @CasePathable
    enum Action {
        case fetchQuestions
        case fetchQuestionsResponse(Result<IdentifiedArrayOf<Question>, MyError>)
        case setQuestions(IdentifiedArrayOf<Question>)
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
            
        case .setQuestions(let questions):
            state.questions = IdentifiedArray(uniqueElements: questions)
            return .send(.startSurvey)
            
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
    private func handleFetchQuestionsResponse(_ result: Result<IdentifiedArrayOf<Question>, MyError>, _ state: inout State) -> Effect<Action> {
        state.isLoading = false
        switch result {
        case .success(let questions):
            
            // TODO: Add an empty screen action here instead of simply returning
            if questions.isEmpty {
                return .none
            }
            
            return .send(.setQuestions(questions))
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
