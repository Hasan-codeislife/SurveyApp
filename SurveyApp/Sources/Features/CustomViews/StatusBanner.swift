//
//  StatusBanner.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import SwiftUI

enum StatusBannerType: Equatable {
    case success
    case failed
    
    var message: String {
        switch self {
        case .success: return "Success"
        case .failed: return "Failed"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .success: return StatusBannerConstants.successColor
        case .failed: return StatusBannerConstants.failedColor
        }
    }
    
    var retryButtonColor: Color? {
        switch self {
        case .failed: return StatusBannerConstants.retryButtonColor
        default: return nil
        }
    }
}

struct StatusBanner: View {
    let type: StatusBannerType
    let retryAction: () -> Void
    
    var body: some View {
        HStack {
            BannerMessage(text: type.message)
            
            if let retryButtonColor = type.retryButtonColor {
                RetryButton(color: retryButtonColor, action: retryAction)
            }
        }
        .padding(Constants.paddingMedium)
        .background(type.backgroundColor)
        .cornerRadius(Constants.cornerRadius)
    }
}

private struct BannerMessage: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(StatusBannerConstants.messageFont)
            .foregroundColor(StatusBannerConstants.messageTextColor)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct RetryButton: View {
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("ui.bannerView.retry".localized)
                .font(StatusBannerConstants.retryButtonFont)
                .padding(Constants.paddingMedium)
                .background(StatusBannerConstants.retryButtonBackgroundColor)
                .foregroundColor(color)
                .cornerRadius(Constants.cornerRadius)
        }
    }
}

private enum StatusBannerConstants {
    static let successColor: Color = .green
    static let failedColor: Color = .red
    static let retryButtonColor: Color = .red
    
    static let messageFont: Font = .headline
    static let messageTextColor: Color = .white
    
    static let retryButtonFont: Font = .subheadline
    static let retryButtonBackgroundColor: Color = .white
}
