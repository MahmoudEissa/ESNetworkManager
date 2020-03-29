//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Mahmoud Eissa on 2/26/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

import XCTest
import ESNetworkManager

class APIClientTests: XCTestCase {
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
    
    func testAPIClient_whenSuccess_isSucceded() {

        let _expectation = expectation(description: "Test Success")
        MockAPIClient.execute(request: .init(base: "", path: "")) { (resposne: ESNetworkResponse<Any>) in
            XCTAssertNotNil(resposne.value)
            _expectation.fulfill()
        }
        waitForExpectations(timeout: 5) {_ in}
    }
    
    func testAPIClient_whenFail_isFailed() {
        MockURLProtocol.responseWithFailure(error: MockURLProtocol.MockError.testError)
         let _expectation = expectation(description: "Test Success")
         MockAPIClient.execute(request: .init(base: "", path: "")) { (resposne: ESNetworkResponse<Any>) in
             XCTAssertNotNil(resposne.error)
             _expectation.fulfill()
         }
         waitForExpectations(timeout: 5) {_ in}
     }
}
