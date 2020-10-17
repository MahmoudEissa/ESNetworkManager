//
//  MPFile.swift
//  Created by Mac on 3/5/19.
//  Copyright © 2019 Mahmoud Eissa. All rights reserved.
//

import UIKit

public class MPFile {
    public let data: Data
    public var key = ""
    public var name = ""
    public var memType = ""
    
    public init(data: Data) {
        self.data = data
    }
    
    public convenience init(data: Data, key: String, name: String, memType: String) {
        self.init(data: data)
        self.name = name
        self.memType = memType
        self.key = key
    }
}
