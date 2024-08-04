//
//  ArticleItemReducer.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/03.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct ArticleItemReducer: Sendable {
    // MARK: - State
    public struct State: Equatable, Identifiable, Sendable {
        public var id: Int { article.id }
        let article: Article
        @BindingState var liked = false

        static func make(from item: ArticleItem) -> Self {
            .init(article: .init(from: item))
        }

//        static func make(from item: SearchFavoritesResponseItem) -> Self {
//            .init(repository: .init(from: item))
//        }
    }

    // MARK: - Action
    public enum Action: BindableAction, Sendable, Equatable {
        case binding(BindingAction<State>)
        
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}

extension IdentifiedArrayOf
where Element == ArticleItemReducer.State, ID == Int {
    init(response: SearchArticlesResponse) {
        self = IdentifiedArrayOf(uniqueElements: response.map { .make(from: $0) })
    }
}

