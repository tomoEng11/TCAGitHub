//
//  QiitaClient.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/01.
//

import Dependencies
import DependenciesMacros

@DependencyClient
public struct QiitaClient: Sendable {
    public var searchRepos: @Sendable (_ query: String, _ page: Int) async throws -> SearchArticlesResponse
    public var searchStock: @Sendable (_ page: Int) async throws -> SearchArticlesResponse
}

extension QiitaClient: TestDependencyKey {
    public static let testValue = Self()
    public static let previewValue = Self()
}

public extension DependencyValues {
    var qiitaClient: QiitaClient {
        get { self[QiitaClient.self] }
        set { self[QiitaClient.self] = newValue }
    }
}
