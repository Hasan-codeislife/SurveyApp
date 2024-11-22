//
//  SubmittedCounterView.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import SwiftUI

struct SubmittedCounterView: View {
    let submittedCount: Int
    let totalCount: Int
    
    var body: some View {
        Rectangle()
            .fill(SubmittedCounterConstants.backgroundColor)
            .overlay(
                CounterText(
                    submittedCount: submittedCount,
                    totalCount: totalCount
                )
            )
            .frame(height: Constants.viewHeight)
    }
}

private struct CounterText: View {
    let submittedCount: Int
    let totalCount: Int
    
    var body: some View {
        Text(
            String(
                format: "ui.submittedCounterView.title".localized,
                submittedCount,
                totalCount
            )
        )
        .padding(Constants.paddingMedium)
    }
}

enum SubmittedCounterConstants {
    static let backgroundColor: Color = .white
}
