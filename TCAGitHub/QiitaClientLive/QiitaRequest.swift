//
//  QiitaRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/08/01.
//

import Foundation
import APIKit

protocol QiitaRequest: BaseRequest {
}

extension QiitaRequest {
    var baseURL: URL { URL(string: "https://qiita.com")! }
    var headerFields: [String: String] { baseHeaders }
    var decoder: JSONDecoder { JSONDecoder() }

    var baseHeaders: [String: String] {
        var params: [String: String] = [:]
        params["Content-Type"] = "application/json"
        //tokenを差し替えると使用可能
        params["Authorization"] = "Bearer \(Confidential.qiitaToken)"

        return params
    }
}
