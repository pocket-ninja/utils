//
//  Copyright © 2022 sroik. All rights reserved.
//

import Combine
import Foundation

public protocol UserDefaultsStorable {}
public protocol UserDefaultsDataStorable: Codable {}

extension String: UserDefaultsStorable {}
extension Bool: UserDefaultsStorable {}
extension Int: UserDefaultsStorable {}
extension Float: UserDefaultsStorable {}
extension Double: UserDefaultsStorable {}
extension Optional: UserDefaultsStorable where Wrapped: UserDefaultsStorable {}

extension Array: UserDefaultsDataStorable where Element: Codable {}
extension Set: UserDefaultsDataStorable where Element: Codable {}
extension Dictionary: UserDefaultsDataStorable where Key: Codable, Value: Codable {}
extension Optional: UserDefaultsDataStorable where Wrapped: UserDefaultsDataStorable {}

public extension Published where Value: UserDefaultsStorable {
    init(wrappedValue value: Value, key: String, defaults: UserDefaults = .standard) {
        self.init(wrappedValue: value, key: key, storage: StandardUserDefaultsStorage(defaults: defaults))
    }
}

public extension Published where Value: RawRepresentable {
    init(wrappedValue value: Value, key: String, defaults: UserDefaults = .standard) {
        self.init(wrappedValue: value, key: key, storage: RawUserDefaultsStorage(defaults: defaults))
    }
}

public extension Published where Value: UserDefaultsDataStorable {
    init(wrappedValue value: Value, key: String, defaults: UserDefaults = .standard) {
        self.init(wrappedValue: value, key: key, storage: DataUserDefaultsStorage(defaults: defaults))
    }
}

public struct StandardUserDefaultsStorage<Value>: PublishedStorage {
    public var defaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func value(forKey key: String) -> Value? {
        defaults.object(forKey: key) as? Value
    }

    public func set(_ value: Value, forKey key: String) {
        if let optional = value as? AnyOptional, optional.isNil {
            defaults.removeObject(forKey: key)
        } else {
            defaults.set(value, forKey: key)
        }
    }
}

public struct RawUserDefaultsStorage<Value: RawRepresentable>: PublishedStorage {
    public var defaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func value(forKey key: String) -> Value? {
        guard let rawValue = defaults.object(forKey: key) as? Value.RawValue else {
            return nil
        }

        return Value(rawValue: rawValue)
    }

    public func set(_ value: Value, forKey key: String) {
        if let optional = value as? AnyOptional, optional.isNil {
            defaults.removeObject(forKey: key)
        } else {
            defaults.set(value.rawValue, forKey: key)
        }
    }
}

public struct DataUserDefaultsStorage<Value: Codable>: PublishedStorage {
    public var defaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func value(forKey key: String) -> Value? {
        guard let data = defaults.object(forKey: key) as? Data else {
            return nil
        }

        let result: Value? = data.maybeDecoded()
        return result
    }

    public func set(_ value: Value, forKey key: String) {
        if let optional = value as? AnyOptional, optional.isNil {
            defaults.removeObject(forKey: key)
            return
        }

        if let data = value.maybeEncoded() {
            defaults.set(data, forKey: key)
        }
    }
}
