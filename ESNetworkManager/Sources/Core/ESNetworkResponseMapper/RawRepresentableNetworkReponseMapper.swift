//
//  RawRepresentableNetworkReponseMapper.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/25/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


open class RawRepresentableNetworkReponseMapper<T>: ESNetworkResponseMapper<T> where T: RawRepresentable {
    override  open func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        guard let rawValue = value.object as? T.RawValue, let _value = T.init(rawValue: rawValue) else {
            return .failure(NSError.init(error: "Failed to initialize \(T.self) from \(value.object)", code: -1))
        }
        return .success(_value)
    }
}
