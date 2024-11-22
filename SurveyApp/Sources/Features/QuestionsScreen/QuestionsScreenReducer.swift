//
//  QuestionsScreenReducer.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import ComposableArchitecture

class QuestionsScreenReducer: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var questions: [Question]
        var currentIndex: Int = 0
        
        var submittedCount: Int {
            questions.filter { $0.isSubmitted }.count
        }
        
        var isLoading: Bool = false
        var errorMessage: String? = nil
        
        var isBannerDismissRunning: Bool = false
        
        // Keep track of the current dismiss task
        var dismissTask: Task<QuestionsScreenReducer.Action, any Error>? = nil
        
        var showBanner: Bool = false
        var bannerType: StatusBannerType = .failed
        
        var navigationTitle: String {
            String(format: "ui.questionScreen.title".localized, (currentIndex + 1), questions.count)
        }
        
        var isPreviousBtnEnabled: Bool { currentIndex > 0 }
        var isNextBtnEnabled: Bool { currentIndex < questions.count - 1 }
    }
    
    @CasePathable
    enum Action {
        case previousBtnTap
        case nextBtnTap
        case setIndex(Int)
        case submitAnswer(Int, String)
        case submissionResponse(Result<Int, MyError>)
        case retrySubmission
        case dismissBanner
    }
    
    private var service: SurveyServiceProtocol
    
    init(service: SurveyServiceProtocol) {
        self.service = service
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .previousBtnTap:
            return handlePreviousButtonTap(&state)
        case .nextBtnTap:
            return handleNextButtonTap(&state)
        case .setIndex(let index):
            return setIndex(index, &state)
        case .submitAnswer(let index, let answer):
            return submitAnswer(index, answer, &state)
        case .submissionResponse(let result):
            return handleSubmissionResponse(result, &state)
        case .retrySubmission:
            return retrySubmission(&state)
        case .dismissBanner:
            return dismissBanner(&state)
        }
    }
    
    // MARK: - Helper Methods
    
    // Previous button tap
    private func handlePreviousButtonTap(_ state: inout State) -> Effect<Action> {
        state.currentIndex = max(0, state.currentIndex - 1)
        return .none
    }
    
    // Next button tap action
    private func handleNextButtonTap(_ state: inout State) -> Effect<Action> {
        state.currentIndex = min(state.questions.count - 1, state.currentIndex + 1)
        return .none
    }
    
    // Handling setIndex action
    private func setIndex(_ index: Int, _ state: inout State) -> Effect<Action> {
        state.currentIndex = index
        return .none
    }
    
    // Handling submitAnswer action
    private func submitAnswer(_ index: Int, _ answer: String, _ state: inout State) -> Effect<Action> {
        state.isLoading = true
        let question = state.questions[index]
        state.questions[index].answer = answer
        
        return .run { send in
            do {
                let response = try await self.service.submitAnswer(question.id, answer)
                if response {
                    await send(.submissionResponse(.success(index)))
                } else {
                    await send(.submissionResponse(.failure(MyError.apiResponseError)))
                }
            } catch {
                await send(.submissionResponse(.failure(MyError.apiResponseError)))
            }
        }
    }
    
    // Handling response of submit answer
    private func handleSubmissionResponse(_ result: Result<Int, MyError>, _ state: inout State) -> Effect<Action> {
        state.isLoading = false
        state.showBanner = true
        state.dismissTask?.cancel()
        switch result {
        case .success(let index):
            state.questions[index].isSubmitted = true
            state.bannerType = .success
        case .failure(let error):
            state.bannerType = .failed
            state.errorMessage = error.localizedDescription
        }
        
        // cancellable task to only execute the last dismissal of the banner
        let task = Task {
            try await Task.sleep(nanoseconds: Constants.timerDuration)
            return Action.dismissBanner
        }
        state.dismissTask = task
        
        return .run { send in
            let dismissAction = try await task.value
            await send(dismissAction)
        }
    }
    
    // Handling retrySubmission action
    private func retrySubmission(_ state: inout State) -> Effect<Action> {
        state.dismissTask?.cancel()
        let index = state.currentIndex
        let answer = state.questions[index].answer
        return .send(.submitAnswer(index, answer))
    }
    
    // Handling dismissBanner action
    private func dismissBanner(_ state: inout State) -> Effect<Action> {
        state.isBannerDismissRunning = false
        state.showBanner = false
        state.dismissTask = nil
        return .none
    }
}
