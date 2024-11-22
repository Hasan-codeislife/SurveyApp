//
//  QuestionTabView.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import SwiftUI

struct QuestionCardView: View {
    let question: Question
    let isLoading: Bool
    let onSubmit: (_ answerText: String) -> Void
    
    @State private var answerText: String = ""
    
    var body: some View {
        VStack(spacing: Constants.spacingMedium) {
            QuestionTextView(text: question.question)
            
            AnswerInputField(
                placeholder: "ui.questionScreen.textfieldPlaceholder".localized,
                answerText: $answerText,
                isEditable: !question.isSubmitted
            )
            
            SubmitButtonSection(
                buttonTitle: question.isSubmitted
                    ? "ui.questionScreen.btn.submitted".localized
                    : "ui.questionScreen.btn.submit".localized,
                isEnabled: !answerText.isEmpty && !question.isSubmitted,
                onSubmit: { onSubmit(answerText) },
                isLoading: isLoading
            )
            
            Spacer()
        }
        .padding()
    }
}

private struct QuestionTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.leading)
            .padding(.bottom, Constants.paddingMedium)
    }
}

private struct AnswerInputField: View {
    let placeholder: String
    @Binding var answerText: String
    let isEditable: Bool
    
    var body: some View {
        TextField(placeholder, text: $answerText)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.cornerRadius)
            .disabled(!isEditable)
            .onChange(of: answerText) { _, newValue in
                let limit = QuestionCardConstants.characterLimit
                if newValue.count > limit {
                    answerText = String(newValue.prefix(limit))
                }
            }
    }
}

private struct SubmitButtonSection: View {
    let buttonTitle: String
    let isEnabled: Bool
    let onSubmit: () -> Void
    let isLoading: Bool
    
    var body: some View {
        VStack {
            CustomButton(text: buttonTitle, isEnabled: isEnabled) {
                onSubmit()
            }
            if isLoading {
                ProgressView()
                    .padding(.top, QuestionCardConstants.loaderPadding)
            }
        }
    }
}

private enum QuestionCardConstants {
    static let loaderPadding: CGFloat = 8
    static let characterLimit: Int = 50
}
