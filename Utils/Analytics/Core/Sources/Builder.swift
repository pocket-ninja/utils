//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol Builder {}
public protocol Withable {}

public extension Builder {
    func set<T>(_ keyPath: WritableKeyPath<Self, T>, to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}

public extension Withable {
    func with(config: (inout Self) -> Void) -> Self {
        var copy = self
        config(&copy)
        return copy
    }
}

extension NSObject: Builder {}
extension NSObject: Withable {}
