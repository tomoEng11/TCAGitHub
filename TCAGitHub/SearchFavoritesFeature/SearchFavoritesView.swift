//
//  SearchFavoritesView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/23.
//

import SwiftUI
import ComposableArchitecture

public struct SearchFavoritesView: View {
    let store: StoreOf<SearchFavoritesReducer>
    
    struct ViewState: Equatable {
        @BindingViewState var showFavoritesOnly: Bool
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchFavoritesReducer.State>) {
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchFavoritesReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            WithViewStore(store, observe: ViewState.init(store:)) { viewStore in

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
                .onAppear {
                    viewStore.send(.viewDidLoad)
                }
            }
        } destination: {
            RepositoryDetailView(store: $0)
        }
    }
}
//
//#Preview {
//    SearchFavoriteView(store: Store(initialState: SearchFavoritesReducer.State(), reducer: {
//        SearchFavoritesReducer()
//    }))
//}
