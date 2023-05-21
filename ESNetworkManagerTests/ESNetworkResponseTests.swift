//
//  ESNetworkResponseTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/14/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
@testable import ESNetworkManager

class ESNetworkResponseTests: XCTestCase {
    
    var sut: ESNetworkResponse<String>!
    
    override func setUp() {
        super.setUp()
        sut = .success("Success")
    }
    
    func testESNetworkResponseTests_whenSuccess_whenGetValue_returnValue() {
        XCTAssertEqual(sut.value, "Success")
    }
    
    func testESNetworkResponseTests_whenSuccess_whenError_returnNil() {
        XCTAssertNil(sut.error)
    }
    
    func testESNetworkResponseTests_whenFailure_whenGetValue_returnValue() {
        sut = .failure(NSError())
        XCTAssertNil(sut.value)
    }
    
    func testESNetworkResponseTests_whenFailure_whenError_returnError() {
        sut = .failure(NSError.init(error: "Error", code: 400))
        XCTAssertNotNil(sut.error)
    }
}
