//
//  Extensions.swift
//  MapPOC
//
//  Created by Mahmoud Eissa on 12/23/19.
//  Copyright © 2019 Mahmoud Eissa. All rights reserved.
//

import Alamofire

public extension NSError {
    convenience init(error: String, code: Int) {
        let userInfo: [String : Any] = [NSLocalizedDescriptionKey :  error]
        self.init(domain: error, code: code, userInfo: userInfo)
    }
}
public extension Error {
    var statusCode: Int {
        if let error = self as? AFError {
            return error.responseCode ?? 0
        }
        return (self as NSError).code
    }
}
public extension Dictionary{
    static func +(lhs: Dictionary, rhs: Dictionary) -> Dictionary{
        var final = lhs
        for obj in rhs{
            final[obj.key] = obj.value
        }
        return final
    }
    static func +=(_ lhs: inout Dictionary, rhs: Dictionary) {
        lhs = lhs + rhs
    }
    func jsonString() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return .none
        }
        return String.init(data: jsonData, encoding: .ascii)
    }
}
