//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public final class Property<Value> {
    public typealias ObservationBlock = (Value) -> Void

    public var value: Value {
        didSet {
            synchronized(self) {
                channel.send(value)
            }
        }
    }

    public init(value: Value) {
        self.value = value
    }

    public func subscribe(on queue: DispatchQueue? = nil,
                          with callback: @escaping ObservationBlock) -> DeinitToken {
        return channel.subscribe(on: queue, with: callback)
    }

    public func bind(on queue: DispatchQueue? = nil,
                     with callback: @escaping ObservationBlock) -> DeinitToken {
        let token = CompositeToken()
        let syncBlock = { [weak self] in
            guard let self = self else {
                return
            }

            synchronized(self) {
                token.addOrIgnore {
                    callback(self.value)
                    return self.subscribe(on: queue, with: callback)
                }
            }
        }

        if let queue = queue {
            queue.async(execute: syncBlock)
        } else {
            syncBlock()
        }

        return DeinitToken(token: token)
    }

    private let channel = Channel<Value>()
}
