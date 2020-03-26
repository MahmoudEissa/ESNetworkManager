//
//  Models.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 3/26/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


import ObjectMapper

// MARK:- ObjectMapper User
class TestMappableUser: Mappable{
    var name = ""
    var age = 0
    required init?(map: Map) {}
    func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
    }
}

// MARK:- Codable User
class TestCodableUser: Codable {
    var name = ""
    var age = 0
    private enum CodingKeys : String, CodingKey {
        case name, age
    }
}

// MARK:- Enum
enum UserType: String {
    case admin = "Admin"
}
