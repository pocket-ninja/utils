//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

@discardableResult
public func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}

public func async<R>(
    _ block: @autoclosure @escaping () -> R,
    in queue: DispatchQueue = .global(qos: .userInteractive),
    callbackQueue: DispatchQueue = .main,
    callback: @escaping (R) -> Void
) {
    queue.async {
        let result = block()
        callbackQueue.async {
            callback(result)
        }
    }
}
