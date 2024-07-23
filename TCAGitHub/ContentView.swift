//
//  ContentView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchRepositoriesView(store: .init(initialState: .init(), reducer: {
                SearchRepositoriesReducer()
            }))
            .tabItem {
                Image(systemName: "cat.circle")
                Text("Github")
            }

            
            SearchFavoriteView()
            .tabItem {
                Image(systemName: "heart.circle")
                Text("GF")
            }

            SearchArticlesView()
            .tabItem {
                Image(systemName: "person.fill.questionmark")
                Text("Qiita")
            }

            SearchLikesView()
            .tabItem {
                Image(systemName: "heart")
                Text("QF")
            }
        }
    }
}

#Preview {
    ContentView()
}