//
//  SearchArticlesRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/03.
//

import APIKit

struct SearchArticlesRequest: QiitaRequest {
    typealias Response = SearchArticlesResponse
    let method = APIKit.HTTPMethod.get
    let path = "/api/v2/items"
    let queryParameters: [String: Any]?

    public init(
        query: String,
        page: Int
    ) {
        self.queryParameters = [
            "query": query,
            "page": page.description,
            "per_page": 10
        ]
    }
}

