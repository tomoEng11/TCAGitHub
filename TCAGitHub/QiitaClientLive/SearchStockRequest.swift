//
//  SearchStockRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/15.
//

import APIKit

struct SearchStockRequest: QiitaRequest {
    typealias Response = SearchArticlesResponse
    let method = APIKit.HTTPMethod.get
    let path = "/api/v2/users/tomodev0015/stocks"
    let queryParameters: [String : Any]?

    public init(
        page: Int
    ) {
        self.queryParameters = [
            "page": page.description,
            "per_page": 10
        ]
    }
}
