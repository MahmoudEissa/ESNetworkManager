//
//  JSON.swift

import Foundation

@dynamicMemberLookup
public enum JSON {
    // MARK: Cases
    case dictionary(Dictionary<String, JSON>)
    case array(Array<JSON>)
    case string(String)
    case number(NSNumber)
    case bool(Bool)
    case null

    // MARK: Dynamic Member Lookup
    public subscript(dynamicMember member: String) -> JSON {
        if case .dictionary = self {
            return self[member]
        }
        if case .array = self, let index = Int(member) {
            return self[index]
        }
        return .null
    }
    // MARK: Subscript
    public subscript(_ key: String) -> JSON {
           if case .dictionary(let dict) = self {
               return dict[key] ?? .null
           }
           return .null
       }
    public subscript(_ index: Int) -> JSON {
        if case .array(let arr) = self {
            return index < arr.count ? arr[index] : .null
        }
        return .null
    }
    public subscript(keys: [Selection]) -> JSON {
        var temp = self
        for key in keys {
            switch key {
            case .key(let string):
                temp = temp[string]
            case .index(let index):
                temp = temp[index]
            }
        }
        return temp
    }

    // MARK: Initializers
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: options)
        self = JSON(object)
    }
    
    public init(_ object: Any?) {
        if let data = object as? Data, let converted = try? JSON(data: data) {
            self = converted
        } else if let dictionary = object as? [String: Any] {
            self = JSON.dictionary(dictionary.mapValues { JSON($0) })
        } else if let array = object as? [Any] {
            self = JSON.array(array.map { JSON($0) })
        } else if let string = object as? String {
            self = JSON.string(string)
        } else if let number = object as? NSNumber {
            self = JSON.number(number)
        }  else if let bool = object as? Bool {
            self = JSON.bool(bool)
        }  else {
            self = JSON.null
        }
    }
    
    // MARK: Accessors
    
    public var dictionary: Dictionary<String, JSON>? {
        if case .dictionary(let value) = self {
            return value
        }
        return nil
    }
    
    public var array: Array<JSON>? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return value ? "true" : "false"
        } else if case .number(let value) = self {
            return value.stringValue
        }
        return nil
    }
    
    public var number: NSNumber? {
        if case .number(let value) = self {
            return value
        } else if case .bool(let value) = self {
            return NSNumber(value: value)
        } else if case .string(let value) = self, let doubleValue = Double(value) {
            return NSNumber(value: doubleValue)
        }
        return nil
    }
    
    public var double: Double? {
        return number?.doubleValue
    }
    
    public var int: Int? {
        return number?.intValue
    }
    
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        } else if case .number(let value) = self {
            return value.boolValue
        } else if case .string(let value) = self,
            (["true", "t", "yes", "y", "1"].contains { value.caseInsensitiveCompare($0) == .orderedSame }) {
            return true
        } else if case .string(let value) = self,
            (["false", "f", "no", "n", "0"].contains { value.caseInsensitiveCompare($0) == .orderedSame }) {
            return false
        }
        return nil
    }
    
    // MARK: Helpers
    
    public var object: Any {
        get {
            switch self {
            case .dictionary(let value): return value.mapValues { $0.object }
            case .array(let value): return value.map { $0.object }
            case .string(let value): return value
            case .number(let value): return value
            case .bool(let value): return value
            case .null: return NSNull()
            }
        }
    }
    public func value<T>() -> T? {
        return self.object as? T
    }
    
    public func data(options: JSONSerialization.WritingOptions = [.prettyPrinted]) -> Data? {
        switch self {
        case .dictionary,
             .array where object is [[String: Any]] :
                return try? JSONSerialization.data(withJSONObject: object, options: options)
        default:
            return .none
        }
    }
}

// MARK: - Comparable

extension JSON: Comparable {
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.dictionary, .dictionary): return lhs.dictionary == rhs.dictionary
        case (.array, .array): return lhs.array == rhs.array
        case (.string, .string): return lhs.string == rhs.string
        case (.number, .number): return lhs.number == rhs.number
        case (.bool, .bool): return lhs.bool == rhs.bool
        case (.null, .null): return true
        default: return false
        }
    }
    
    public static func < (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.string, .string):
            if let lhsString = lhs.string, let rhsString = rhs.string {
                return lhsString < rhsString
            }
            return false
        case (.number, .number):
            if let lhsNumber = lhs.number, let rhsNumber = rhs.number {
                return lhsNumber.doubleValue < rhsNumber.doubleValue
            }
            return false
        default: return false
        }
    }
}

// MARK: - ExpressibleByLiteral

extension JSON: Swift.ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        let dictionary = elements.reduce(into: [String: Any](), { $0[$1.0] = $1.1})
        self.init(dictionary)
    }
}

extension JSON: Swift.ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
}

extension JSON: Swift.ExpressibleByStringLiteral {
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension JSON: Swift.ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

// MARK: - Pretty Print

extension JSON: Swift.CustomStringConvertible, Swift.CustomDebugStringConvertible {
    
    public var description: String {
        return String(describing: self.object as AnyObject).replacingOccurrences(of: ";\n", with: "\n")
    }
    
    public var debugDescription: String {
        return description
    }
}
public enum Selection {
    case key(_ key: String)
    case index(_ index: Int)
}
