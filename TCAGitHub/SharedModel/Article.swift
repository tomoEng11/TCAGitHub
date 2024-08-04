//
//  Article.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/03.
//

import Foundation

public struct Article: Equatable, Sendable {
    public let id: Int
    public let title: String
    public let profileImageUrl: URL
    public let likesCount: Int
    public let name: String
}

public extension Article {
    init (from item:ArticleItem) {
        // IDない時にどう実装するか考える
        self.id = 1
        self.title = item.title
        self.profileImageUrl = item.user.profileImageUrl
        self.likesCount = item.likesCount
        self.name = item.user.name
    }
}
