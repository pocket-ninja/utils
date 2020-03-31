//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

open class Cacher<Item: Cacheable, Value> {
    public typealias Generator = (Item) -> Value?

    public init(generator: @escaping Generator) {
        self.generator = generator
    }

    @discardableResult
    open func cache(item: Item, update: Bool = false) -> Value? {
        return synchronized(self) {
            _cache(item: item, update: update)
        }
    }

    open func cached(item: Item) -> Value? {
        return synchronized(self) {
            cache.object(forKey: item.cacheId)?.value
        }
    }

    open func cache(_ value: Value, for item: Item) {
        synchronized(self) {
            cache.setObject(ValueWrapper(value), forKey: item.cacheId)
        }
    }

    open func removeCache(for item: Item) {
        synchronized(self) {
            cache.removeObject(forKey: item.cacheId)
        }
    }

    @discardableResult
    private func _cache(item: Item, update: Bool = false) -> Value? {
        if !update, let cachedValue = cached(item: item) {
            return cachedValue
        }

        guard let value = generator(item) else {
            return nil
        }

        cache(value, for: item)
        return value
    }

    private var cache = NSCache<AnyObject, ValueWrapper<Value>>()
    private let generator: Generator
}

public protocol Cacheable {
    var cacheId: AnyObject { get }
}

extension String: Cacheable {
    public var cacheId: AnyObject { return self as NSString }
}
