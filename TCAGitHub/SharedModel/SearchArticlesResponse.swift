//
//  SearchArticlesResponse.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/03.
//

import Foundation

public typealias SearchArticlesResponse = [ArticleItem]

public struct ArticleItem: Sendable, Decodable, Equatable {

    public let title: String
    public let user: User
    public let likesCount: Int

    public init(
        title: String,
        user: User,
        likesCount: Int
    ) {
        self.title = title
        self.user = user
        self.likesCount = likesCount
    }

    enum CodingKeys: String, CodingKey {
        case title
        case user
        case likesCount = "likes_count"
    }
}

public struct User: Sendable, Decodable, Equatable {
    public let name: String
    public let profileImageUrl: URL

    public init(
        name: String,
        profileImageUrl: URL
    ) {
        self.name = name
        self.profileImageUrl = profileImageUrl
    }

    enum CodingKeys: String, CodingKey {
        case name
        case profileImageUrl = "profile_image_url"
    }
}

