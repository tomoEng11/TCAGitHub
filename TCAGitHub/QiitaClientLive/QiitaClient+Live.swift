//
//  QiitaClientLive.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/01.

import Foundation
import Dependencies

extension QiitaClient: DependencyKey {
    public static let liveValue: QiitaClient = .live()

    static func live(apiClient: ApiClient = .liveValue) -> Self {
        .init(
            searchRepos: { query, page in
                try await apiClient.send(request: SearchArticlesRequest(query: query, page: page))
            }, searchStock: { page in
                try await apiClient.send(request: SearchStockRequest(page: page))
            }
            )
    }
}
