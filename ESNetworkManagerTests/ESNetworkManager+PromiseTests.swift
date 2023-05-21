//
//  ESNetworkManager+PromiseTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/15/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
import PromiseKit
@testable import ESNetworkManager

class ESNetworkManager_PromiseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenCodable_dataRequest_whenSuccess_isSucceded() {
        

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let promise: Promise<String> = NetworkManager.execute(request: request)
        
        _ = promise.done { response in
            XCTAssertEqual(response, "Super hero squad")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentable_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let promise: Promise<UserType> = NetworkManager.execute(request: request)
        
        _ = promise.done { response in
            XCTAssertEqual(response, .admin)
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let promise: Promise<[UserType]> = NetworkManager.execute(request: request)
        
        _ = promise.done { response in
            XCTAssertEqual(response, [.admin])
            expetation.fulfill()
        }.catch{ error in
            print(error)
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenCodable_uploadRequest_whenSuccess_isSucceded() {
                
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let expetation  = expectation(description: "test promise uploadRequest")
        let promise: Promise<String> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        _ = promise.done { response in
            XCTAssertEqual(response, "Super hero squad")
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentable_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let expetation  = expectation(description: "test promise uploadRequest")
        let promise: Promise<UserType> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        _ = promise.done { response in
            XCTAssertEqual(response, .admin)
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let expetation  = expectation(description: "test promise uploadRequest")
        let promise: Promise<[UserType]> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        _ = promise.done { response in
            XCTAssertEqual(response, [.admin])
            expetation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenDownloadRequest_whenSuccess_success() {
                
        let expectation = expectation(description: "test upload request")
        let request = ESNetworkRequest(url: "http://any.com")
        let promise: Promise<URL> = NetworkManager.download(request: request) { _ in }
        
        _ = promise.done { url in
            let json = JSON(try? Data.init(contentsOf: url))
            XCTAssertEqual(json.squadName.value(), "Super hero squad")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenResumeDownloadRequest_whenSuccess_success() {
                
        let expectation = expectation(description: "test upload request")
        let promise: Promise<URL> = NetworkManager.resumeDownload(resumingData: Data()) { _ in }
        
        _ = promise.done { url in
            let json = JSON(try? Data.init(contentsOf: url))
            XCTAssertEqual(json.squadName.value(), "Super hero squad")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }

}
