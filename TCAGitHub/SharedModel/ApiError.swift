//
//  APIError.swift
//  TCAGitHub
//
//  Created by 井本智博 on 2024/07/16.
//

import Foundation

public enum ApiError: Error, Equatable {
    case unacceptableStatusCode(Int)
    case unknown(NSError)
}
