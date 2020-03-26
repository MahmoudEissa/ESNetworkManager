//
//  NetworkEnums.swift
//  DesignPatterns
//
//  Created by Mahmoud Eissa on 7/8/19.
//  Copyright © 2019 Mahmoud Eissa. All rights reserved.
//


import Foundation

public enum ESNetworkResponse<T> {
    case success(T)
    case failure(Error)
}

public extension ESNetworkResponse {
    var error: Error? {
        if case .failure(let error) = self {
            return error
        }
        return .none
    }
    var value: T? {
        if case .success(let value) = self {
            return value
        }
        return .none
    }
}
