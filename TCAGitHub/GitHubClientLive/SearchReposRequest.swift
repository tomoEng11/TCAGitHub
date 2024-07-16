//
//  SearchReposRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import APIKit

struct SearchReposRequest: GithubRequest {
    typealias Response = SearchReposResponse
    let method = APIKit.HTTPMethod.get
    let path = "/search/repositories"
    let queryParameters: [String: Any]?

    public init(
        query: String,
        page: Int
    ) {
        self.queryParameters = [
            "q": query,
            "page": page.description,
            "per_page": 10
        ]
    }
}

