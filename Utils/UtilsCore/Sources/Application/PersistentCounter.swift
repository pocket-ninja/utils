//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol PersistentCounterProtocol {
    var count: UInt { get }
    func advance(by: UInt)
}

public extension PersistentCounterProtocol {
    func increase() {
        advance(by: 1)
    }
}

public final class PersistentCounter: PersistentCounterProtocol {
    public var count: UInt {
        return UInt(storage.int(forKey: domain) ?? 0)
    }

    public init(storage: Storage, domain: String) {
        self.storage = storage
        self.domain = domain
    }

    public func advance(by: UInt) {
        storage.set(Int(count + by), forKey: domain)
    }

    private let domain: String
    private let storage: Storage
}
