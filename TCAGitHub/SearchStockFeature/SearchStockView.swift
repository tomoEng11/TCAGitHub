//
//  SearchStockView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/23.
//

import SwiftUI
import ComposableArchitecture

struct SearchStockView: View {
    let store: StoreOf<SearchStockReducer>
    struct ViewState: Equatable {
        @BindingViewState var showFavoritesOnly: Bool
        let isLoading: Bool

        init(store: BindingViewStore<SearchStockReducer.State>) {
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.isLoading = store.isLoading
        }
    }

    var body: some View {
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
                                state: ArticleDetailReducer.State(
                                    article: itemViewStore.article,
                                    liked: itemViewStore.liked
                                )
                            ) {
                                ArticleItemView(store: itemStore)
                                    .onAppear {
                                        viewStore.send(.itemAppeared(itemViewStore.article.id))
                                    }
                            }
                        }
                    }

                    if viewStore.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .onAppear {
                    viewStore.send(.viewDidLoad)
                }
            }
        } destination: {
            ArticleDetailView(store: $0)
        }
    }
}

//#Preview {
//    SearchStockView(store: .init(initialState: Search, reducer: <#T##() -> Reducer#>))
//}
