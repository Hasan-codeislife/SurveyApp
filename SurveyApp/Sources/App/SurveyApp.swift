//
//  SurveyApp.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import ComposableArchitecture
import SwiftUI

@main
struct SurveyApp: App {
    
    private static let store = Store(initialState: InitialScreenReducer.State(), reducer: {
        InitialScreenReducer(service: SurveyService.create())
    })
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            InitialScreen(store: SurveyApp.store)
        }
    }
}
