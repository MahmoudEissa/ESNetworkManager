//
//  MockSessionManager.swift
//  APIClientTests
//
//  Created by Mahmoud Eissa on 2/24/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//


import Foundation
final class MockURLProtocol: URLProtocol {
    
    static var responseType: ResponseType!
    private(set) var activeTask: URLSessionTask?
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
    }()
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel() // We don’t want to make a network request, we want to return our stubbed data ASAP
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didLoad: response.data)
            client?.urlProtocol(self, didReceive: response.response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}
extension MockURLProtocol {
    static func responseWithFailure(error: Error) {
        MockURLProtocol.responseType = .error(error)
    }
    
    static func responseWithStatusCode(code: Int, data: Data) {
        let response = HTTPURLResponse(url: URL(string: "http://any.com")!,
                                       statusCode: code,
                                       httpVersion: nil, headerFields: nil)!
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(response: response, data: data)
    }
}
extension MockURLProtocol {
    enum ResponseType {
        case error(Error)
        case success(response: HTTPURLResponse, data: Data)
    }
    enum MockError: Error {
        case none
        case testError
    }
}
