//
//  SearchFavoritesReducer.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/25.
//

import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct SearchFavoritesReducer: Sendable {
    // MARK: - State

    public struct State: Equatable, Sendable {
        @BindingState var showFavoritesOnly = false
        var items = IdentifiedArrayOf<RepositoryItemReducer.State>()
        var currentPage = 1
        var isLoading = false
        var loadingState: LoadingState = .refreshing
        var path = StackState<RepositoryDetailReducer.State>()
        var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
            showFavoritesOnly ? items.filter { $0.liked } : items
        }

        public init() {}
    }

    public enum LoadingState: Equatable, Sendable {
        case refreshing
        case loadingNext
        case none
    }

    // MARK: - Action
    public enum Action:BindableAction, Sendable {
        case searchFavoritesResponse(Result<SearchFavoritesResponse, Error>)
        case viewDidLoad
        case binding(BindingAction<State>)
        case path(StackAction<RepositoryDetailReducer.State, RepositoryDetailReducer.Action>)
        case items(IdentifiedActionOf<RepositoryItemReducer>)
        case itemAppeared(id: Int)
    }

    // MARK: - Dependencies
    @Dependency(\.githubClient) var githubClient
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case let .searchFavoritesResponse(.success(response)):
                switch state.loadingState {
                    
                case .refreshing:
                    state.items = IdentifiedArrayOf<RepositoryItemReducer.State>(response: response)
                    state.isLoading = false

                case .loadingNext:
                    let newItems = IdentifiedArrayOf<RepositoryItemReducer.State>(response: response)
                    state.items.append(contentsOf: newItems)
                    state.isLoading = false

                case .none:
                    state.isLoading = false
                    break
                }
                state.loadingState = .none
                return .none


            case let .searchFavoritesResponse(.failure(error)):
                return .none

            case .viewDidLoad:
                state.isLoading = true
                let page = state.currentPage
                return .run { send in
                    await send(.searchFavoritesResponse(Result {
                        try await githubClient.searchFavorites(page: page)
                    }))
                }

            case let .path(.element(id: id, action: .binding(\.$liked))):
                guard let repositoryDetail = state.path[id: id] else { return .none }
                state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
                return .none

            case let .itemAppeared(id: id):
                state.isLoading = true
                if state.items.index(id: id) == state.items.count - 1 {
                    state.currentPage += 1
                    state.loadingState = .loadingNext

                    let page = state.currentPage

                    return .run { send in
                        await send(.searchFavoritesResponse(Result {
                            try await githubClient.searchFavorites(page: page)
                        }))

                    }
                } else {
                    return .none
                }

            case .path:
                return .none

            case .items:
                return .none
            }
        }
        .forEach(\.items, action: \.items) {
            RepositoryItemReducer()
        }

        .forEach(\.path, action: \.path) {
            RepositoryDetailReducer()
        }
    }
}
