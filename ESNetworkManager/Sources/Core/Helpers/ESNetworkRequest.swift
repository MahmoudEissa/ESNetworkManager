//
//  Request.swift
//
//  Created by Mac on 2/12/19.
//  Copyright © 2019 Mahmoud Eissa. All rights reserved.
//

import Alamofire

public class ESNetworkRequest {
    
    ///The ***Network Base Url***
    public var base = ""
    
    ///The ***Network API Path*** ex ..api\login
    public var path = ""
    public var method = HTTPMethod.get
    public var headers: [String: String]?
    public var parameter: [String: Any]?
    public var encoding: ParameterEncoding = URLEncoding.default
    public var selections: [Selection] = []
 
    public init(base: String,
         path: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         parameter: [String: Any]? = nil,
         encoding: ParameterEncoding = URLEncoding.default ) {
        self.base = base
        self.path = path
        self.method = method
        self.headers = headers
        self.parameter = parameter
        self.encoding = encoding
    }
}
public extension ESNetworkRequest {
    var fullPath: String {
        return (base + "/" + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
     }
}
extension ESNetworkRequest: CustomStringConvertible {
    public var description: String {
        var temp = "--------------------------------------------------\n"
        temp.append("\(method.rawValue): \(fullPath)\n")
        if let headers = headers {
            temp.append("Headers: \(headers.jsonString() ?? "{}")\n")
        }
        if let parameter = parameter {
            temp.append("Body: \(parameter.jsonString() ?? "{}")\n")
        }
        temp.append("--------------------------------------------------")
        return temp
    }
}
