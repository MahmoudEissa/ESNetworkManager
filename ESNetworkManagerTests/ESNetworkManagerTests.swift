//
//  APIClientTests.swift
//  APIClientTests
//
//  Created by Mahmoud Eissa on 2/26/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

import XCTest
@testable import ESNetworkManager

class ESNetworkManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testESNetworkManager_whenDataRequest_whenSuccess_isSucceded() {
        
        MockURLProtocol.responseType = .success(data: Data.mock)

        let expectation = expectation(description: "test data request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.execute(request: request) { (resposne: ESNetworkResponse<JSON>) in
            guard case .success(let resposne) = resposne else {
                return XCTFail()
            }
            print(resposne.description)
            XCTAssertEqual(resposne.squadName.value(), "Super hero squad")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenUploadRequest_whenSuccess_isSucceded() {
        
        MockURLProtocol.responseType = .success(data: Data.mock)

        let expectation = expectation(description: "test upload request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.upload(data: .multipart([]), request: request, progress: { _ in
            
        }, completion: { (resposne: ESNetworkResponse<JSON>) in
            guard case .success(let resposne) = resposne else {
                return XCTFail()
            }
            XCTAssertEqual(resposne.squadName.value(), "Super hero squad")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 4)
    }

    
    func testESNetworkManager_whenDownloadRequest_whenSuccess_isSucceded() {
        
        MockURLProtocol.responseType = .success(data: Data.mock)

        let expectation = expectation(description: "test download request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.download(request: request, progress: { _ in
            
        }, completion: { resposne in
            guard case .success(let url) = resposne else {
                return XCTFail()
            }
            let json = JSON(try? Data.init(contentsOf: url))
            XCTAssertEqual(json.squadName.value(), "Super hero squad")
            expectation.fulfill()
        })
        waitForExpectations(timeout: 4)
    }
        
    func testESNetworkManager_whenDataRequest_whenError_isFailed() {
        
        MockURLProtocol.responseType = .error(NSError(domain: "failure", code: 400))

        let expectation = expectation(description: "test data request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.execute(request: request) { (resposne: ESNetworkResponse<JSON>) in
            XCTAssertNotNil(resposne.error)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenUploadRequest_whenError_isFailed() {
        
        MockURLProtocol.responseType = .error(NSError(domain: "failure", code: 400))

        let expectation = expectation(description: "test upload request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.upload(data: .multipart([]), request: request, progress: { _ in
            
        }, completion: { (resposne: ESNetworkResponse<JSON>) in
            XCTAssertNotNil(resposne.error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenDownloadRequest_whenError_isFailed() {
        
        MockURLProtocol.responseType = .error(NSError(domain: "failure", code: 400))

        let expectation = expectation(description: "test download request")
        let request = ESNetworkRequest(url: "http://any.com")
        
        NetworkManager.download(request: request, progress: { _ in
            
        }, completion: { resposne in
            XCTAssertNotNil(resposne.error)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 4)
    }
}
