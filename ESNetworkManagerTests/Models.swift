//
//  Models.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 3/26/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


 import ObjectMapper

// MARK:- Enum
enum UserType: String {
    case admin = "admin"
}

class OAPIResponse: ObjectMapper.Mappable {
    var squadName = ""
    var members: [OMember] = []

    required init?(map: ObjectMapper.Map) { }
    
    func mapping(map: ObjectMapper.Map) {
        squadName <- map["squadName"]
        members <- map["members"]
    }
}

class OMember: ObjectMapper.Mappable {
    var name = ""
    var age = 0
    
    required init?(map: ObjectMapper.Map) { }
    
    func mapping(map: ObjectMapper.Map) {
        name <- map["name"]
        age <- map["age"]
    }
}

class DAPIResponse: Codable {
    let squadName: String
    let members: [DMember]
}

class DMember: Codable {
    let name: String
    let age: Int
}
