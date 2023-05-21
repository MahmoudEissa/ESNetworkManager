//
//  ESNetworkManager+AsyncTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/14/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
@testable import ESNetworkManager

class ESNetworkManager_AsyncTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenCodable_dataRequest_whenSuccess_isSucceded() async throws {
        

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let resposne: String = try await NetworkManager.execute(request: request)

        XCTAssertEqual(resposne, "Super hero squad")
    }
    
    func testESNetworkManager_whenRawRepresentable_dataRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let resposne: UserType = try await NetworkManager.execute(request: request)

        XCTAssertEqual(resposne, .admin)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_dataRequest_whenSuccess_isSucceded() async throws {
        
        MockURLProtocol.responseType = .success(data: Data.mock)

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let resposne: [UserType] = try await NetworkManager.execute(request: request)

        XCTAssertEqual(resposne, [.admin])
    }
    
    func testESNetworkManager_whenCodable_uploadRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let resposne: String = try await NetworkManager.upload(data: .multipart([]), request: request) {_ in}

        XCTAssertEqual(resposne, "Super hero squad")
    }
    
//    func testESNetworkManager_whenRawRepresentable_uploadRequest_whenSuccess_isSucceded() async throws {
//        
//        let request = ESNetworkRequest(url: "http://any.com")
//        request.selections = [.key("rule")]
//        
//        let resposne: UserType = try await NetworkManager.upload(data: .multipart([]), request: request) {_ in }
//
//        XCTAssertEqual(resposne, .admin)
//    }
//    
    func testESNetworkManager_whenRawRepresentableArray_uploadRequest_whenSuccess_isSucceded() async throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let resposne: [UserType] = try await NetworkManager.upload(data: .multipart([]), request: request) {_ in}

        XCTAssertEqual(resposne, [.admin])
    }
}
