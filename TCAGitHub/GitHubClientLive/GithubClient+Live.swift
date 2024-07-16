//
//  GithubClient+Live.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import Dependencies

extension GithubClient: DependencyKey {
    public static let liveValue: GithubClient = .live()

    static func live(apiClient: ApiClient = .liveValue) -> Self {
        .init(
            searchRepos: { query, page in
                try await apiClient.send(request: SearchReposRequest(query: query, page: page))
            }
        )
    }
}
