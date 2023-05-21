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
        } else if let data = object as? Data, let string = String(data: data, encoding: .utf8) {
            self = .string(string)
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
        case .string(let string):
            return string.data(using: .utf8)
        case .dictionary,
                .array where object is [[String: Any]] :
            return try? JSONSerialization.data(withJSONObject: object, options: options)
        default:
            return .none
        }
    }
}
public enum Selection {
    case key(_ key: String)
    case index(_ index: Int)
}
