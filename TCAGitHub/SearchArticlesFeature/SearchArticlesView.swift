//
//  SearchArticlesView.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/23.
//

import SwiftUI
import ComposableArchitecture

struct SearchArticlesView: View {
    let store: StoreOf<SearchArticlesReducer>
    struct ViewState: Equatable {
        @BindingViewState var showFavoritesOnly: Bool
        let hasMorePage: Bool

        init(store: BindingViewStore<SearchArticlesReducer.State>) {
            self._showFavoritesOnly = store.$showFavoritesOnly
            self.hasMorePage = store.hasMorePage
        }
    }

    public init(store: StoreOf<SearchArticlesReducer>) {
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
                                state: ArticleDetailReducer.State(
                                    article: itemViewStore.article,
                                    liked: itemViewStore.liked
                                )
                            ) {
                                ArticleItemView(store: itemStore)
                                    .onAppear {
                                        viewStore.send(.itemAppeared)
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
            ArticleDetailView(store: $0)
        }
    }
}

//#Preview {
//    SearchArticlesView(store: <#StoreOf<SearchArticlesReducer>#>)
//}
