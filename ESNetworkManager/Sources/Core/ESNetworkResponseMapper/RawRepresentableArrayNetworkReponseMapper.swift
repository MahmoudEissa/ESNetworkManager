//
//  RawRepresentableArrayNetworkReponseMapper.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/25/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


open class RawRepresentableArrayNetworkReponseMapper<T>: ESNetworkResponseMapper<T> where T: Sequence, T.Element: RawRepresentable {
    override  open func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        guard let array = value.object as? [T.Element.RawValue] else {
            return .failure(NSError.init(error: "Failed to initialize \(T.self) from \(value.object)", code: -1))
        }
        
        let indexes = array.filter({ T.Element.init(rawValue: $0) == nil })
        
        if !indexes.isEmpty {
            return .failure(NSError.init(error: "Failed to initialize \(T.self) from \(indexes)", code: -1))
        }
        
        guard let values = array.compactMap({T.Element.init(rawValue: $0)}) as? T else {
            return .failure(NSError.init(error: "Failed to initialize \(T.self) from \(array)", code: -1))
        }
        return .success(values)
    }
}
