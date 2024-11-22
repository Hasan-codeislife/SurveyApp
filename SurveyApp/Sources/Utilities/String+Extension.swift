//
//  String+Extension.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: .main, comment: "")
    }
}
