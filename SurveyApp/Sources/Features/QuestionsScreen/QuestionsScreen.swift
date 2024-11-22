//
//  QuestionsScreen.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import ComposableArchitecture
import SwiftUI

struct QuestionsScreen: View {
    @Bindable var store: StoreOf<QuestionsScreenReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    if viewStore.showBanner {
                        StatusBanner(type: viewStore.bannerType) {
                            viewStore.send(.retrySubmission)
                        }
                    }
                    
                    SubmittedCounterView(
                        submittedCount: viewStore.submittedCount,
                        totalCount: viewStore.questions.count
                    )
                    
                    QuestionCarousel(
                        questions: viewStore.questions,
                        currentIndexBinding: viewStore.binding(get: \.currentIndex, send: { .setIndex($0) }),
                        isLoading: viewStore.isLoading
                    ) { index, answer in
                        viewStore.send(.submitAnswer(index, answer))
                    }
                }
                .navigationTitle(viewStore.navigationTitle)
                .toolbar {
                    NavigationToolbar(
                        isPreviousEnabled: viewStore.isPreviousBtnEnabled,
                        isNextEnabled: viewStore.isNextBtnEnabled,
                        onPreviousTap: { viewStore.send(.previousBtnTap) },
                        onNextTap: { viewStore.send(.nextBtnTap) }
                    )
                }
            }
        }
    }
}

private struct QuestionCarousel: View {
    let questions: [Question]
    let currentIndexBinding: Binding<Int>
    let isLoading: Bool
    let onSubmit: (Int, String) -> Void
    
    var body: some View {
        TabView(selection: currentIndexBinding) {
            ForEach(questions.indices, id: \.self) { index in
                QuestionCardView(
                    question: questions[index],
                    isLoading: isLoading
                ) { answer in
                    onSubmit(index, answer)
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear { UIScrollView.appearance().isScrollEnabled = false }
    }
}

private struct NavigationToolbar: ToolbarContent {
    let isPreviousEnabled: Bool
    let isNextEnabled: Bool
    let onPreviousTap: () -> Void
    let onNextTap: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: Constants.spacingSmall) {
                Button(action: onPreviousTap) {
                    Text("ui.previousButton.title".localized)
                }
                .disabled(!isPreviousEnabled)
                
                Button(action: onNextTap) {
                    Text("ui.nextButton.title".localized)
                }
                .disabled(!isNextEnabled)
            }
        }
    }
}

#Preview {
    let mockQuestions: [Question] = [
        Question(id: 1, question: "What is your favorite color?"),
        Question(id: 2, question: "How many continents are there on Earth?"),
        Question(id: 3, question: "What is the capital of France?")
    ]
    let store = Store(initialState: QuestionsScreenReducer.State(questions: mockQuestions), reducer: {
        QuestionsScreenReducer(service: SurveyService.create())
    })
    QuestionsScreen(store: store)
}
