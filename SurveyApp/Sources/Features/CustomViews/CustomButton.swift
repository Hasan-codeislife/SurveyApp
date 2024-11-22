//
//  CustomButton.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(text)
                .modifier(ButtonTextModifier(isEnabled: isEnabled))
                .frame(maxWidth: .infinity)
                .frame(height: Constants.viewHeight)
                .background(isEnabled ? ButtonConstants.enabledBackground : ButtonConstants.disabledBackground)
                .cornerRadius(Constants.cornerRadius)
        }
        .padding(.horizontal, Constants.paddingMedium)
        .disabled(!isEnabled)
    }
}

private struct ButtonTextModifier: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: ButtonConstants.fontSize, weight: .bold))
            .foregroundColor(.white)
    }
}

private enum ButtonConstants {
    static let fontSize: CGFloat = 16
    static let enabledBackground: Color = .purple
    static let disabledBackground: Color = .gray
}
