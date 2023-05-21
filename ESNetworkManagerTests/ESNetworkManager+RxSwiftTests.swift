//
//  ESNetworkManager+RxSwiftTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/15/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
import RxSwift
@testable import ESNetworkManager

class ESNetworkManager_RxSwiftTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = .init()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = nil
    }
    
    func testESNetworkManager_whenCodable_dataRequest_whenSuccess_isSucceded() {
        

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<String> = NetworkManager.execute(request: request)
        
        source.subscribe { response in
            XCTAssertEqual(response, "Super hero squad")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentable_dataRequest_whenSuccess_isSucceded() {
                
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<UserType> = NetworkManager.execute(request: request)
        
        source.subscribe { response in
            XCTAssertEqual(response, .admin)
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_dataRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<[UserType]> = NetworkManager.execute(request: request)
        
        source.subscribe { response in
            XCTAssertEqual(response, [.admin])
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenCodable_uploadRequest_whenSuccess_isSucceded() {
                
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<String> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        
        source.subscribe { response in
            XCTAssertEqual(response, "Super hero squad")
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentable_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<UserType> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        
        source.subscribe { response in
            XCTAssertEqual(response, .admin)
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_uploadRequest_whenSuccess_isSucceded() {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let expetation  = expectation(description: "test promise dataRequest")
        let source: Single<[UserType]> = NetworkManager.upload(data: .multipart([]), request: request) { _ in }
        
        
        source.subscribe { response in
            XCTAssertEqual(response, [.admin])
            expetation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenDownloadRequest_whenSuccess_success() {
                
        let expectation = expectation(description: "test upload request")
        let request = ESNetworkRequest(url: "http://any.com")
        let source: Single<URL> = NetworkManager.download(request: request) { _ in }
        
        source.subscribe { url in
            let json = JSON(try? Data.init(contentsOf: url))
            XCTAssertEqual(json.squadName.value(), "Super hero squad")
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }
    
    func testESNetworkManager_whenResumeDownloadRequest_whenSuccess_success() {
        
        let expectation = expectation(description: "test upload request")
        let source: Single<URL> = NetworkManager.resumeDownload(resumingData: Data()) { _ in }
        
        source.subscribe { url in
            let json = JSON(try? Data.init(contentsOf: url))
            XCTAssertEqual(json.squadName.value(), "Super hero squad")
            expectation.fulfill()
        }.disposed(by: disposeBag)
        
        waitForExpectations(timeout: 4)
    }

}
