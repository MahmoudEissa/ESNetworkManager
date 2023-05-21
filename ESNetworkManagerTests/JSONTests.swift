//
//  JSONTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/22/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//


import XCTest
@testable import ESNetworkManager

class JSONTests: XCTestCase {
    var sut: JSON!
    override func setUp() {
        super.setUp()
        sut = .init(Data.mock)
    }
    
    func tesJSONAccessors() {
        XCTAssertEqual(sut.squadName.value(), "Super hero squad")
        XCTAssertEqual(sut.rules.value(), ["admin"])
        XCTAssertEqual(sut.formed.value(), 2016)
        XCTAssertEqual(sut.active.value(), true)
        XCTAssertEqual(sut.members[0].name.value(), "Molecule Man")
        XCTAssertTrue(sut.object is [String: Any])
        XCTAssertEqual(sut.squadName.data(), "Super hero squad".data(using: .utf8)!)
    }
}
