//
//  SearchFavoritesResponse.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/25.
//

import Foundation

public typealias SearchFavoritesResponse = [SearchFavoritesResponseItem]

public struct SearchFavoritesResponseItem: Sendable, Decodable, Equatable {

    public let id: Int
    public let name: String
    public let fullName: String
    public let owner: Owner
    public let description: String?
    public let stargazersCount: Int

    public init(
        id: Int,
        name: String,
        fullName: String,
        owner: Owner,
        description: String?,
        stargazersCount: Int
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.owner = owner
        self.description = description
        self.stargazersCount = stargazersCount
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case description
        case stargazersCount = "stargazers_count"
    }
}

public struct Owner: Sendable, Decodable, Equatable {
    public let login: String
    public let avatarUrl: URL

    public init(
        login: String,
        avatarUrl: URL
    ) {
        self.login = login
        self.avatarUrl = avatarUrl
    }

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
