//
//  MappableNetworkReponseMapper.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/25/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//
#if canImport(ObjectMapper)
import ObjectMapper
open class MappableNetworkReponseMapper<T>: ESNetworkResponseMapper<T> where T: BaseMappable {
    override  open func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        guard let json = value.object as? [String: Any] else {
            return .failure(NSError.init(error: "Unable to cast \(value) to Dictionary", code: -1))
        }

        guard let object = Mapper<T>().map(JSON: json) else {
            return .failure(NSError.init(error: "Unable to map \(Self.self) from \(value)", code: -1))
            
        }
        return .success(object)
    }
}
#endif
