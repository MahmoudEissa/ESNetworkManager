//
//  MockAPIClient.swift
//  APIClientTests
//
//  Created by Mahmoud Eissa on 2/24/20.
//  Copyright © 2020 Mahmoud Eissa. All rights reserved.
//

import ESNetworkManager
import Alamofire

class MockAPIClient: ESNetworkManager {
    static let session: Session = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        return Session(configuration: configuration)
    }()
    
    override class var Manager: Session {
        return session
    }
}

class NetworkManager: ESNetworkManager {
    
    static let session: Session = {
        let manager = ServerTrustManager(evaluators: ["serverurl.com": DisabledEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    override class var Manager: Session {
        return session
    }
}
