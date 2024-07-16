//
//  TCAGitHubApp.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import SwiftUI

@main
struct TCAGitHubApp: App {
    var body: some Scene {
        WindowGroup {
            SearchRepositoriesView(store: .init(initialState: .init()) {
                SearchRepositoriesReducer()
            })
        }
    }
}
