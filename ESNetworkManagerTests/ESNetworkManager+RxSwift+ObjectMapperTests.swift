//
//  ESNetworkManager+RxSwift+ObjectMapperTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/22/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
import RxSwift
@testable import ESNetworkManager

class ESNetworkManager_RxSwift_ObjectMapperTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = .init()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenMappable_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
    
        let expetation  = expectation(description: "test promise dataRequest")
        
        let source: Single<OAPIResponse> = NetworkManager.execute(request: request)
        
        source.subscribe { response in
            XCTAssertEqual(response.squadName, "Super hero squad")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappableArray_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]
        
        let expetation  = expectation(description: "test promise dataRequest")

        let source: Single<[OMember]> = NetworkManager.execute(request: request)
        
        source.subscribe { response in
            XCTAssertEqual(response.first?.name, "Molecule Man")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappable_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
    
        let expetation  = expectation(description: "test promise dataRequest")
        
        let source: Single<OAPIResponse> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        source.subscribe { response in
            XCTAssertEqual(response.squadName, "Super hero squad")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenMappableArray_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("members")]
        
        let expetation  = expectation(description: "test promise dataRequest")

        let source: Single<[OMember]> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        source.subscribe { response in
            XCTAssertEqual(response.first?.name, "Molecule Man")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        waitForExpectations(timeout: 4)
    }
}
