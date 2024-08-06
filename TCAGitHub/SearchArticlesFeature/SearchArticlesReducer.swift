//
//  SearchArticlesReducer.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/01.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
public struct SearchArticlesReducer: Sendable {
    public struct State: Equatable, Sendable {
        var items = IdentifiedArrayOf<ArticleItemReducer.State>()
        @BindingState var showFavoritesOnly = false
        var currentPage = 1
        var loadingState: LoadingState = .refreshing
        var hasMorePage = false
        var path = StackState<ArticleDetailReducer.State>()
        var searchBar =  CustomSearchBarFeature.State()

        var filteredItems: IdentifiedArrayOf<ArticleItemReducer.State> {
            showFavoritesOnly ? items.filter { $0.liked } : items
        }

        public init() {}
    }

    enum LoadingState: Equatable {
        case refreshing
        case loadingNext
        case none
    }

    public enum Action: BindableAction, Sendable {
        case itemAppeared
        case items(IdentifiedActionOf<ArticleItemReducer>)
        case binding(BindingAction<State>)
        case searchArticlesResponse(Result<SearchArticlesResponse, Error>)
        case path(StackAction<ArticleDetailReducer.State, ArticleDetailReducer.Action>)

        case searchBar(CustomSearchBarFeature.Action)
    }

    @Dependency(\.qiitaClient) var qiitaClient
    @Dependency(\.mainQueue) var mainQueue

    private enum CancelId { case searchRepos }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {

            case .binding:
                return .none

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

//                state.hasMorePage = response.totalCount > state.items.count
                state.loadingState = .none
                return .none

            case let .searchArticlesResponse(.failure(error)):
                print(error)
                return .none

            case .searchBar(.submit):

                guard !state.searchBar.text.isEmpty else {
                    state.hasMorePage = false
                    state.items.removeAll()
                    return .cancel(id: CancelId.searchRepos)
                }

                state.currentPage = 1
                state.loadingState = .refreshing
                let query = state.searchBar.text
                let page = state.currentPage

                return .run { send in
                    await send(.searchArticlesResponse(Result {
                        try await qiitaClient.searchRepos(query: query, page: page)
                    }))
                }

            case .searchBar(_):
                return .none

            case let .path(.element(id: id, action: .binding(\.$liked))):
                guard let articleDetail = state.path[id: id] else { return .none }
                state.items[id: articleDetail.id]?.liked = articleDetail.liked
                return .none

            case .path:
                return .none

            case .itemAppeared:
                state.currentPage += 1
                state.loadingState = .loadingNext

                let page = state.currentPage
                let query = state.searchBar.text

                return .run { send in
                    await send(.searchArticlesResponse(Result {
                        try await qiitaClient.searchRepos(query: query, page: page)
                    }))
                }

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

        Scope(state: \.searchBar, action: \.searchBar) {
                CustomSearchBarFeature()
        }
    }
}
