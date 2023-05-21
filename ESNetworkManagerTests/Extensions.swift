//
//  Extensions.swift
//  ESNetworkManagerTests
//
//  Created by Mahmoud Eissa on 2/14/23.
//  Copyright © 2023 Mahmoud Eissa. All rights reserved.
//

import Foundation

extension Data {
    static var mock: Data {
        let bundle = Bundle.init(for: MockURLProtocol.self)
        let url = bundle.url(forResource: "Data", withExtension: "json")
        return try! .init(contentsOf: url!)
    }
}
