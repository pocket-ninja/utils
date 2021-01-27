//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension Int {
    func times(_ block: () throws -> Void) rethrows {
        for _ in 0 ..< Swift.max(0, self) {
            try block()
        }
    }
}

public extension BinaryFloatingPoint where Self: Comparable {
    var signum: Self {
        self / abs(self)
    }
}

public extension Comparable {
    func clamped(from: Self, to: Self) -> Self {
        assertWrapper(from <= to, "invalid clamp range", "`to` should be greater than `from`")
        return min(max(self, from), to)
    }

    func between(_ c1: Self, _ c2: Self) -> Bool {
        return self >= min(c1, c2) && self <= max(c1, c2)
    }
}
