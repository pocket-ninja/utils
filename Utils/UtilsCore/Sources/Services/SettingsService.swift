//
// Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public final class SettingsService<S: Codable & Hashable> {
    public typealias TweakBlock = (inout S) -> Void

    public var settings: S {
        return settingsProperty.value
    }

    public init(storage: Storage, domain: String, defaultSettings: S) {
        self.storage = storage
        self.domain = domain
        self.settingsProperty = Property(value: defaultSettings)

        do {
            if let data = storage.data(forKey: domain) {
                self.settingsProperty.value = try JSONDecoder().decode(S.self, from: data)
            }
        } catch {
            trace("corrupted settings json")
        }
    }

    public func backup(_ settings: S) {
        settingsProperty.value = settings
        assertError {
            let data = try JSONEncoder().encode(settings)
            storage.set(data, forKey: domain)
        }
    }

    public func tweak(_ block: TweakBlock) {
        synchronized(self) {
            var tweakedSettings = settings
            block(&tweakedSettings)
            backup(tweakedSettings)
        }
    }

    public func subscribe(on queue: DispatchQueue? = nil,
                          with callback: @escaping (S) -> Void) -> DeinitToken {
        return settingsProperty.subscribe(on: queue, with: callback)
    }

    public func bind(on queue: DispatchQueue? = nil, with callback: @escaping (S) -> Void) -> DeinitToken {
        return settingsProperty.bind(on: queue, with: callback)
    }

    private let settingsProperty: Property<S>
    private let storage: Storage
    private let domain: String
}
