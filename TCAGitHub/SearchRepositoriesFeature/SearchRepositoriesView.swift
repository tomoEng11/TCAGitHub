//
//  SearchRepositoriesView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import SwiftUI
import ComposableArchitecture

public struct SearchRepositoriesView: View {
    let store: StoreOf<SearchRepositoriesReducer>
    struct ViewState: Equatable {
        @BindingViewState var showFavoritesOnly: Bool
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchRepositoriesReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            WithViewStore(store, observe: ViewState.init(store:)) { viewStore in

                CustomSearchBarView(store: store.scope(state: \.searchBar, action: \.searchBar))
                
                List {
                    Toggle(isOn: viewStore.$showFavoritesOnly) {
                        Text("Favorites Only")
                    }

                    ForEachStore(store.scope(
                        state: \.filteredItems,
                        action: \.items
                    )) { itemStore in
                        WithViewStore(itemStore, observe: { $0 }) { itemViewStore in
                            NavigationLink(
                                state: RepositoryDetailReducer.State(
                                    repository: itemViewStore.repository,
                                    liked: itemViewStore.liked
                                )
                            ) {
                                RepositoryItemView(store: itemStore)
                                    .onAppear {
                                        viewStore.send(.itemAppeared(id: itemStore.withState(\.id)))
                                    }
                            }
                        }
                    }

                    if viewStore.hasMorePage {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        } destination: {
            RepositoryDetailView(store: $0)
        }
    }
}

//#Preview {
//    SearchRepositoriesView(
//        store: .init(initialState: SearchRepositoriesReducer.State()) {
//            SearchRepositoriesReducer()
//                .dependency(
//                    \.githubClient,
//                     SearchReposResponse.init(searchRepos: { _, _ in .mock() })
//                )
//        }
//    )
//}
//
//#Preview {
//    SearchRepositoriesView(store: .init(initialState: SearchRepositoriesReducer.State(), reducer: {
//        SearchRepositoriesReducer()
//            .dependency(\.githubClient, .previewValue)
//    }))
//}
