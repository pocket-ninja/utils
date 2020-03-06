//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol Storage {
    func value(forKey key: String) -> Any?
    func set(_ value: Any?, forKey key: String)
}

public final class InMemoryStorage: Storage {
    public init() {}

    public func value(forKey key: String) -> Any? {
        return hash[key]
    }

    public func set(_ value: Any?, forKey key: String) {
        hash[key] = value
    }

    private var hash: [String: Any] = [:]
}

public extension Storage {
    func set(_ value: UUID, forKey key: String) {
        let string = value.uuidString
        set(string, forKey: key)
    }

    func data(forKey key: String) -> Data? {
        return value(forKey: key) as? Data
    }

    func bool(forKey key: String) -> Bool? {
        return value(forKey: key) as? Bool
    }

    func int(forKey key: String) -> Int? {
        return value(forKey: key) as? Int
    }

    func uint(forKey key: String) -> UInt? {
        return value(forKey: key) as? UInt
    }

    func double(forKey key: String) -> Double? {
        return value(forKey: key) as? Double
    }

    func uuid(forKey key: String) -> UUID? {
        let string = value(forKey: key) as? String
        return string.flatMap(UUID.init(uuidString:))
    }

    func string(forKey key: String) -> String? {
        return value(forKey: key) as? String
    }
}

extension UserDefaults: Storage {}
