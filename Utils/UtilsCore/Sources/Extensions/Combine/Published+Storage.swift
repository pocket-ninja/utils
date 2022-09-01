//
//  Copyright © 2022 sroik. All rights reserved.
//

import Combine
import Foundation

public protocol PublishedStorage {
    associatedtype Value
    func value(forKey key: String) -> Value?
    func set(_ value: Value, forKey key: String)
}

private var cancellables = [String: AnyCancellable]()

public extension Published {
    init<Storage: PublishedStorage>(
        wrappedValue value: Value,
        key: String,
        storage: Storage
    ) where Storage.Value == Value {
        self.init(initialValue: storage.value(forKey: key) ?? value)

        cancellables[key] = projectedValue.sink { value in
            storage.set(value, forKey: key)
        }
    }
}
