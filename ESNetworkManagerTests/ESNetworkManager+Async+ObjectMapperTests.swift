//
//  ESNetworkManager+Async+ObjectMapperTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/22/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//


import XCTest
@testable import ESNetworkManager

class ESNetworkManager_Async_ObjectMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenMappable_dataRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        
        let response: OAPIResponse = try await NetworkManager.execute(request: request)

        XCTAssertEqual(response.squadName, "Super hero squad")
    }
    
    func testESNetworkManager_whenMappableArray_dataRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]

        let response: [OMember] = try await NetworkManager.execute(request: request)

        XCTAssertEqual(response.first?.name, "Molecule Man")
    }
    
    func testESNetworkManager_whenMappable_uploadRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        
        let response: OAPIResponse = try await NetworkManager.upload(data: .multipart([]), request: request) {_ in}

        XCTAssertEqual(response.squadName, "Super hero squad")
    }
    
    func testESNetworkManager_whenMappableArray_uploadRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]

        let response: [OMember] = try await NetworkManager.upload(data: .multipart([]), request: request) {_ in}

        XCTAssertEqual(response.first?.name, "Molecule Man")
    }
}
