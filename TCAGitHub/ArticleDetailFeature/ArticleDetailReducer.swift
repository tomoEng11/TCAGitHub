//
//  ArticleDetailReducer.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/04.
//
import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct ArticleDetailReducer: Reducer, Sendable {
    // MARK: - State
    public struct State: Equatable, Sendable {
        public var id: UUID { article.id }
        public let article: Article
        @BindingState public var liked = false

        public init(
            article: Article,
            liked: Bool
        ) {
            self.article = article
            self.liked = liked
        }
    }

    public init() {}

    // MARK: - Action
    public enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
    }

    // MARK: - Dependencies

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}
