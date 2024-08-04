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
        var isLoading = false
        var path = StackState<RepositoryDetailReducer.State>()
        var filteredItems: IdentifiedArrayOf<RepositoryItemReducer.State> {
            showFavoritesOnly ? items.filter { $0.liked } : items
        }

        public init() {}
    }


    // MARK: - Action
    public enum Action:BindableAction, Sendable {
        case searchFavoritesResponse(Result<SearchFavoritesResponse, Error>)
        case viewDidLoad
        case binding(BindingAction<State>)
        case path(StackAction<RepositoryDetailReducer.State, RepositoryDetailReducer.Action>)
        case items(IdentifiedActionOf<RepositoryItemReducer>)
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
                state.items = IdentifiedArrayOf<RepositoryItemReducer.State>(response: response)
                state.isLoading = false
                return .none

            case let .searchFavoritesResponse(.failure(error)):
                return .none

            case .viewDidLoad:
                state.isLoading = true
                return .run { send in
                    await send(.searchFavoritesResponse(Result {
                        try await githubClient.searchFavorites()
                    }))
                }

            case let .path(.element(id: id, action: .binding(\.$liked))):
                guard let repositoryDetail = state.path[id: id] else { return .none }
                state.items[id: repositoryDetail.id]?.liked = repositoryDetail.liked
                return .none

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
