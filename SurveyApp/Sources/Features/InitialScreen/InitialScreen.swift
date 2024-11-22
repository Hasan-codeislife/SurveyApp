//
//  InitialScreen.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import ComposableArchitecture
import SwiftUI

struct InitialScreen: View {
    @Bindable var store: StoreOf<InitialScreenReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                ContentView(viewStore: viewStore)
                    .navigationDestination(
                        isPresented: viewStore.binding(
                            get: \.shouldStartSurvey,
                            send: .surveyDismiss
                        )
                    ) {
                        NavigationDestinationView(questions: viewStore.questions)
                    }
                    .navigationTitle("ui.initialScreen.title".localized)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

private struct ContentView: View {
    let viewStore: ViewStore<InitialScreenReducer.State, InitialScreenReducer.Action>
    
    var body: some View {
        VStack {
            CustomButton(
                text: "ui.initialScreen.button.title".localized,
                isEnabled: !viewStore.isLoading
            ) {
                viewStore.send(.fetchQuestions)
            }
            if viewStore.isLoading {
                ProgressIndicator()
            }
        }
    }
}

private struct ProgressIndicator: View {
    var body: some View {
        ProgressView()
            .padding(.top, InitialScreenConstants.loaderPadding)
    }
}

private struct NavigationDestinationView: View {
    let questions: [Question]?
    
    var body: some View {
        if let questions = questions {
            let store = Store(
                initialState: QuestionsScreenReducer.State(questions: questions),
                reducer: { QuestionsScreenReducer(service: SurveyService.create()) }
            )
            QuestionsScreen(store: store)
        } else {
            // TODO: Can show a no data found like screen here
            EmptyView()
        }
    }
}

private enum InitialScreenConstants {
    static let loaderPadding: CGFloat = 16
}
