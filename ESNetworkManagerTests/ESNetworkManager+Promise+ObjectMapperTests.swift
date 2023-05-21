//
//  ESNetworkManager+Promise+ObjectMapperTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/22/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
import PromiseKit
@testable import ESNetworkManager

class ESNetworkManager_Promise_ObjectMapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenMappable_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
    
        let expetation  = expectation(description: "test promise dataRequest")
        
        let promise: Promise<OAPIResponse> = NetworkManager.execute(request: request)
        
        _ = promise.done { response in
            XCTAssertEqual(response.squadName, "Super hero squad")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappableArray_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]
        
        let expetation  = expectation(description: "test promise dataRequest")

        let promise: Promise<[OMember]> = NetworkManager.execute(request: request)
        
        _ = promise.done { response in
            XCTAssertEqual(response.first?.name, "Molecule Man")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappable_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
    
        let expetation  = expectation(description: "test promise dataRequest")
        
        let promise: Promise<OAPIResponse> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        _ = promise.done { response in
            XCTAssertEqual(response.squadName, "Super hero squad")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappableArray_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]
        
        let expetation  = expectation(description: "test promise dataRequest")

        let promise: Promise<[OMember]> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        _ = promise.done { response in
            XCTAssertEqual(response.first?.name, "Molecule Man")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
}
