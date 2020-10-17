//
//  NetworkResponseMapper.swift
//  Created by Mahmoud Eissa on 1/19/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


open class ESNetworkResponseMapper<T> {
    public init() {}
    open  func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        
        if let _value = value as? T {
            return .success(_value)
        }
        
        guard let _value = value.object as? T else {
            return .failure(NSError.init(error: "Unbale to cast \(value.object) to \(T.self)", code: -1))
        }
        return .success(_value)
    }
}
