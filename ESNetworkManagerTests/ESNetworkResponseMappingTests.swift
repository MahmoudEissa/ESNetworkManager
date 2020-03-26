//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Mahmoud Eissa on 2/24/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

import XCTest
import ESNetworkManager
import ObjectMapper

class ESNetworkManagerResponseMappingTests: XCTestCase {
    private let dictionary: [String: Any] = ["name": "Demo User",
                                       "age": 41,
                                       "type": "Admin",
                                       "roles": ["Admin"],
                                       "verified": 0,
                                       "activated": true,
                                       "phones": ["134234", "532412"],
                                       "adddress": ["title": "Cairo", "latitude": "12.23123", "logintude": "41.12323"],
                                       "family": [["name": "Demo Son", "age": 19, "activated": false]]]
    
    private var data: Data {
        return try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    }
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseWithStatusCode(code: 200, data: data)
    }
    func testAPIClient_whenMapping_canMapString()  {
        let expectedValue = "Demo User"
        canMap(mapper: CodableNetworkResponseMapper(), selection: [.key("name")]) { $0 == expectedValue  }
    }
    
    func testAPIClient_whenMapping_canMapInt()  {
        let expectedValue = 41
        canMap(mapper: CodableNetworkResponseMapper(), selection: [.key("age")]) { $0 == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapBool()  {
        let expectedValue = true
        canMap(mapper: CodableNetworkResponseMapper(), selection: [.key("activated")]) { $0 == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapArray()  {
        let expectedValue = ["134234", "532412"]
        canMap(mapper: CodableNetworkResponseMapper(), selection: [.key("phones")]) { $0 == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapDictionary()  {
        let expectedValue = ["title": "Cairo", "latitude": "12.23123", "logintude": "41.12323"]
        canMap(mapper: CodableNetworkResponseMapper(), selection: [.key("adddress")]) { $0 == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapMappable()  {
        let expectedValue = "Demo User"
        canMap(mapper: MappableNetworkReponseMapper<TestMappableUser>(), selection: []) { $0.name == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapCodable()  {
        let expectedValue = "Demo User"
        canMap(mapper: CodableNetworkResponseMapper<TestCodableUser>(), selection: []) { $0.name == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapMappableArray()  {
        let expectedValue = "Demo Son"
        canMap(mapper: MappableArrayNetworkReponseMapper<[TestMappableUser]>(), selection: [.key("family")]) { $0.first!.name == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapCodableArray()  {
        let expectedValue = "Demo Son"
        canMap(mapper: CodableNetworkResponseMapper<[TestCodableUser]>(), selection: [.key("family")]) { $0.first!.name == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapRawRepresentable()  {
        let expectedValue: UserType = .admin
        canMap(mapper: RawRepresentableNetworkReponseMapper<UserType>(), selection: [.key("type")]) { $0 == expectedValue }
    }
    
    func testAPIClient_whenMapping_canMapRawRepresentableArray()  {
        let expectedValue: [UserType] = [.admin]
        canMap(mapper: RawRepresentableArrayNetworkReponseMapper<[UserType]>(), selection: [.key("roles")]) { $0 == expectedValue }
    }
}

extension ESNetworkManagerResponseMappingTests {
    func canMap<T>(mapper: ESNetworkResponseMapper<T>, selection: [Selection], closure: @escaping (_ t: T) -> Bool) {
        let request = ESNetworkRequest.init(base: "", path: "")
        request.selections = selection
        let _expectation = expectation(description: "Test Mapping \(T.self)")
        let completion: Completion<T> = { response in
            guard let value =  response.value else {
                XCTAssert(false, response.error!.localizedDescription)
                return
            }
            XCTAssert(closure(value))
            _expectation.fulfill()
        }
        MockAPIClient.execute(request: request, mapper: mapper, completion: completion)
        waitForExpectations(timeout: 5) {_ in}
    }
}

