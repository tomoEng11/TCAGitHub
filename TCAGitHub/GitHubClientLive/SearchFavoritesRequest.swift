//
//  SearchFavoritesRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/25.
//

import APIKit

struct SearchFavoritesRequest: GithubRequest {
    typealias Response = SearchFavoritesResponse
    let method = APIKit.HTTPMethod.get
    let path = "/users/tomoEng11/starred"
    let queryParameters: [String: Any]?

    public init(
        page: Int
    ) {
        self.queryParameters = [
            "page": page.description,
            "per_page": 10
        ]
    }

}

