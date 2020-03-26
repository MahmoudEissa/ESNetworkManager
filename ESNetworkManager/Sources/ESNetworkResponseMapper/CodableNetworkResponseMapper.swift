//
//  CodableNetworkResponseMapper.swift
//  ESNetworkManager
//
//  Created by Mahmoud Eissa on 2/25/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

open class CodableNetworkResponseMapper<T>: ESNetworkResponseMapper<T> where T: Codable {
    override  open func map(_ response: ESNetworkResponse<JSON>, selections: [Selection]) -> ESNetworkResponse<T> {
        guard case .success(var value) = response else {
            return .failure(response.error!)
        }
        value = value[selections]
        // For Basic types
        if let value = value.object as? T {
            return .success(value)
        }
        
        // For Codable
        guard let data = value.data() else {
            return .failure(NSError.init(error: "Unable to get data from \(value)", code: -1))
        }
        
        do {
            let object = try JSONDecoder().decode(T.self, from: data)
            return .success(object)
        } catch {
            return .failure(error)
        }
    }
}
