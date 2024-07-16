//
//  GithubRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import Foundation
import APIKit

protocol GithubRequest: BaseRequest {
}

extension GithubRequest {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var headerFields: [String: String] { baseHeaders }
    var decoder: JSONDecoder { JSONDecoder() }

    var baseHeaders: [String: String] {
        var params: [String: String] = [:]
        params["Accept"] = "application/vnd.github+json"
        //tokenを差し替えると使用可能
//        params["Authorization"] = "Bearer \(Confidential.token)"

        return params
    }
}

