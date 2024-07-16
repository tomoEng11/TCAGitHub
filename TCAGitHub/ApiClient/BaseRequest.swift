//
//  BaseRequest.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import Foundation
import APIKit

public protocol BaseRequest: Request where Response: Decodable {
    var decoder: JSONDecoder { get }
}

public extension BaseRequest {
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            throw ApiError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        let data = try JSONSerialization.data(withJSONObject: object, options: [])
        return try decoder.decode(Response.self, from: data)
    }
}
