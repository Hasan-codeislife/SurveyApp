//
//  QuestionScreenReducerTests.swift
//  SurveyApp
//
//  Created by Hassan Personal on 20.11.24.
//

import Foundation
import Testing
import ComposableArchitecture
@testable import SurveyApp

@MainActor
final class QuestionsScreenReducerTests {
    
    var service: MockSurveyService!
    
    init() {
        service = MockSurveyService()
    }
    
    @Test func navigationButtons() async {
        
        let questions = MockData.mockQuestions
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
        await store.send(.nextBtnTap) {
            #expect(!$0.isPreviousBtnEnabled, "Previous button should be inactive on the first question")
            if questions.count > 1 {
                #expect($0.isNextBtnEnabled, "Next button should be enabled to show next question")
            }
            $0.currentIndex = 1
        }
        
        await store.send(.previousBtnTap) {
            $0.currentIndex = 0
        }
    }
    
    @Test func submitAnswerSuccess() async {
        
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
        store.exhaustivity = .off
        service.shouldSucceed = true
        
        await store.send(.submitAnswer(0, "Answer 1")) {
            $0.isLoading = true
            $0.questions[0].answer = "Answer 1"
        }
        
        await store.receive({ action in
            guard case .submissionResponse(.success(0)) = action else { return false }
            return true
        }) { state in
            state.isLoading = false
            state.showBanner = true
            state.bannerType = .success
            state.questions[0].isSubmitted = true
            #expect(state.submittedCount == 1, "Submit question count should increase from 0 to one")
            let isCancelled = state.dismissTask?.isCancelled ?? false
            #expect(!isCancelled, "Dismiss task should execute at response")
        }
    }
    
    @Test func submitAnswerFailed() async {
        
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
        store.exhaustivity = .off
        service.shouldSucceed = false
        
        await store.send(.submitAnswer(0, "Answer 1")) {
            $0.isLoading = true
            $0.questions[0].answer = "Answer 1"
        }
        
        await store.receive({ action in
            guard case .submissionResponse(.failure(MyError.apiResponseError)) = action else { return false }
            return true
        }) { state in
            state.isLoading = false
            state.showBanner = true
            state.bannerType = .failed
            state.questions[0].isSubmitted = false
            #expect(state.submittedCount == 0, "Submit question count should not increase from 0 to one")
            let isCancelled = state.dismissTask?.isCancelled ?? false
            #expect(!isCancelled, "Dismiss task should execute at response")
        }
    }
    
    @Test func dismissBanner() async {
        
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
       
        // no change to state should occur
        await store.send(.dismissBanner)
    }
    
    @Test func retrySubmissionPreventsPrematureDismissal() async {
        
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
        store.exhaustivity = .off
        service.shouldSucceed = false
        
        // Simulate a submission failure
        await store.send(.submitAnswer(0, "Answer 1")) {
            $0.isLoading = true
            $0.questions[0].answer = "Answer 1"
        }
        
        await store.receive({ action in
            guard case .submissionResponse(.failure(MyError.apiResponseError)) = action else { return false }
            return true
        }) { state in
            state.isLoading = false
            state.showBanner = true
            state.bannerType = .failed
            state.isBannerDismissRunning = false
            let isCancelled = state.dismissTask?.isCancelled ?? false
            #expect(!isCancelled, "Dismiss task should execute at response")
        }
        
        // Retry the submission
        await store.send(.retrySubmission) {
            $0.isBannerDismissRunning = false // Cancel previous dismissal
            $0.isLoading = false
            let isCancelled = $0.dismissTask?.isCancelled ?? false
            #expect(isCancelled, "Dismiss task should be cancelled on retry")
        }
        
        // Simulate a success on retry
        service.shouldSucceed = true
        
        await store.receive({ action in
            guard case .submitAnswer(0, "Answer 1") = action else { return false }
            return true
        }) { state in
            state.isLoading = true
            state.questions[0].answer = "Answer 1"
        }
    }
}
