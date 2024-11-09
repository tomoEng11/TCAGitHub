//
//  SearchStockReducer.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/15.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct SearchStockReducer: Sendable {

    struct State: Equatable, Sendable {
        @BindingState var showFavoritesOnly = false
        var items = IdentifiedArrayOf<ArticleItemReducer.State>()
        var path = StackState<ArticleDetailReducer.State>()
        var currentPage = 1
        var loadingState: LoadingState = .refreshing
        var isLoading = false

        var filteredItems: IdentifiedArrayOf<ArticleItemReducer.State> {
            showFavoritesOnly ? items.filter { $0.liked } : items
        }
    }

    enum LoadingState: Equatable {
        case refreshing
        case loadingNext
        case none
    }

    enum Action: BindableAction, Sendable {
        case viewDidLoad
        case itemAppeared(UUID)
        case binding(BindingAction<State>)
        case items(IdentifiedActionOf<ArticleItemReducer>)
        case path(StackAction<ArticleDetailReducer.State, ArticleDetailReducer.Action>)
        case searchArticlesResponse(Result<SearchArticlesResponse, Error>)
    }

    @Dependency(\.qiitaClient) var qiitaClient

    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .viewDidLoad:
                state.loadingState = .refreshing
                state.isLoading = true
                let page = state.currentPage
                return .run { send in
                    await send(.searchArticlesResponse(Result {
                        try await qiitaClient.searchStock(page: page)
                    }))
                }

            case let .itemAppeared(id):

                if let lastItem = state.items.last, lastItem.id == id {
                    state.currentPage += 1
                    state.loadingState = .loadingNext

                    let page = state.currentPage

                    return .run { send in
                        await send(.searchArticlesResponse(Result {
                            try await qiitaClient.searchStock(page: page)
                        }))
                    }
                } else {
                    return .none
                }

            case let .searchArticlesResponse(.success(response)):
                switch state.loadingState {
                case .refreshing:
                    state.items = .init(response: response)
                case .loadingNext:
                    let newItems = IdentifiedArrayOf(response: response)
                    state.items.append(contentsOf: newItems)
                case .none:
                    break
                }

                state.loadingState = .none
                state.isLoading = false
                return .none

            case let .searchArticlesResponse(.failure(error)):
                print(error)
                state.isLoading = false
                return .none

            case let .path(.element(id: id, action: .binding(\.$liked))):
                guard let articleDetail = state.path[id: id] else { return .none }
                state.items[id: articleDetail.id]?.liked = articleDetail.liked
                return .none

            case .path:
                return .none

            case .items:
                return .none
            }
        }
        .forEach(\.items, action: \.items) {
            ArticleItemReducer()
        }
        .forEach(\.path, action: \.path) {
            ArticleDetailReducer()
        }
    }
}
