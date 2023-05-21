//
//  MPFileTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/22/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//


import XCTest
@testable import ESNetworkManager

class MPFileTests: XCTestCase {
    
    var sut: MPFile!
    
    override func setUp() {
        super.setUp()
        sut = .init(data: Data.mock, key: "key", name: "file.txt", memType: "text/plain")
    }
    
    func test_MPFile_initialize() {
        XCTAssertEqual(sut.data, Data.mock)
        XCTAssertEqual(sut.key, "key")
        XCTAssertEqual(sut.name, "file.txt")
        XCTAssertEqual(sut.memType, "text/plain")
    }
}
