//
//  Request.swift
//
//  Created by Mac on 2/12/19.
//  Copyright © 2019 Mahmoud Eissa. All rights reserved.
//

import Alamofire

public class ESNetworkRequest {
    
    public private(set) var url: String
    public var method = HTTPMethod.get
    public var headers: [String: String]?
    public var parameters: [String: Any]?
    public var encoding: ParameterEncoding = URLEncoding.default
    public var selections: [Selection] = []
 
    public init(url: String,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         parameters: [String: Any]? = nil,
         encoding: ParameterEncoding = URLEncoding.default) {
        self.url = url
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
    }
}
extension ESNetworkRequest: CustomStringConvertible {
    public var description: String {
        var temp = "--------------------------------------------------\n"
        temp.append("\(method.rawValue): \(url)\n")
        if let headers = headers {
            temp.append("Headers: \(headers.jsonString() ?? "{}")\n")
        }
        if let parameters = parameters {
            temp.append("Body: \(parameters.jsonString() ?? "{}")\n")
        }
        temp.append("--------------------------------------------------")
        return temp
    }
}
