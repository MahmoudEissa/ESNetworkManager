//
//  ESNetworkManager+CombineTests.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/15/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import XCTest
import Combine
@testable import ESNetworkManager

class ESNetworkManager_CombineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.responseType = .success(data: Data.mock)
    }
    
    func testESNetworkManager_whenCodable_dataRequest_whenSuccess_isSucceded()  throws  {

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let response: String = try awaitPublisher(NetworkManager.execute(request: request))
        
        XCTAssertEqual(response, "Super hero squad")
    }
    
    func testESNetworkManager_whenRawRepresentable_dataRequest_whenSuccess_isSucceded() throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let resposne: UserType = try awaitPublisher(NetworkManager.execute(request: request))

        XCTAssertEqual(resposne, .admin)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_dataRequest_whenSuccess_isSucceded() throws {
        
        MockURLProtocol.responseType = .success(data: Data.mock)

        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let resposne: [UserType] = try awaitPublisher(NetworkManager.execute(request: request))

        XCTAssertEqual(resposne, [.admin])
    }
    
    func testESNetworkManager_whenCodable_uploadRequest_whenSuccess_isSucceded() throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("squadName")]
        
        let resposne: String = try awaitPublisher(NetworkManager.upload(data: .multipart([]), request: request) {_ in })

        XCTAssertEqual(resposne, "Super hero squad")
    }
    
    func testESNetworkManager_whenRawRepresentable_uploadRequest_whenSuccess_isSucceded() throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rule")]
        
        let resposne: UserType = try awaitPublisher(NetworkManager.upload(data: .multipart([]), request: request) {_ in })

        XCTAssertEqual(resposne, .admin)
    }
    
    func testESNetworkManager_whenRawRepresentableArray_uploadRequest_whenSuccess_isSucceded() throws {
        
        let request = ESNetworkRequest(url: "http://any.com")
        request.selections = [.key("rules")]
        
        let resposne: [UserType] = try awaitPublisher(NetworkManager.upload(data: .multipart([]), request: request) {_ in })

        XCTAssertEqual(resposne, [.admin])
    }
}
internal extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 4,
        file: StaticString = #file,
        line: UInt = #line
    )  throws  -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
