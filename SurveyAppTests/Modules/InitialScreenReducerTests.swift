//
//  InitialScreenReducerTests.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import Foundation
import Testing
import ComposableArchitecture
@testable import SurveyApp

final class InitialScreenReducerTests {
    
    var service: MockSurveyService!
    // var store: TestStore<InitialScreenReducer.State, InitialScreenReducer.Action>!
    
    init() {
        service = MockSurveyService()
       
    }
    
    @Test func fetchQuestionsSuccess() async {
        
        let store = await TestStore(initialState: InitialScreenReducer.State(), reducer: {
             InitialScreenReducer(service: service)
         })
        service.shouldSucceed = true
        
        await store.send(.fetchQuestions) {
            $0.isLoading = true
        }
        
        await store.receive {
            guard case .fetchQuestionsResponse = $0 else { return false }
            return true
        } assert: {
            $0.isLoading = false
            $0.questions = MockData.mockQuestions
        }
        
        await store.receive {
            guard case .startSurvey = $0 else { return false }
            return true
        } assert: {
            $0.shouldStartSurvey = true
            $0.isLoading = false
        }
    }
    
    @Test func fetchQuestionsFailure() async {
        
        let store = await TestStore(initialState: InitialScreenReducer.State(), reducer: {
             InitialScreenReducer(service: service)
         })
        service.shouldSucceed = false
        
        await store.send(.fetchQuestions) {
            $0.isLoading = true
        }
        
        await store.receive {
            guard case .fetchQuestionsResponse = $0 else { return false }
            return true
        } assert: {
            $0.isLoading = false
            $0.questions = nil
            $0.errorMessage = MockData.error.localizedDescription
        }
        
    }
}
