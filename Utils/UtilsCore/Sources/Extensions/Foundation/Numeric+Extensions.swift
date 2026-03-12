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

public extension Comparable {
    func clamped(from: Self, to: Self) -> Self {
        assertWrapper(from <= to, "invalid clamp range", "`to` should be greater than `from`")
        return min(max(self, from), to)
    }
    
    func clamped(in range: ClosedRange<Self>) -> Self {
        min(max(range.lowerBound, self), range.upperBound)
    }

    func between(_ c1: Self, _ c2: Self) -> Bool {
        return self >= min(c1, c2) && self <= max(c1, c2)
    }
}

@inlinable
public func lerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(_ from: V, _ to: V, _ time: T) -> V {
    from + V(time) * (to - from)
}

@inlinable
public func lerp<V: BinaryFloatingPoint, T: BinaryFloatingPoint>(from: V, to: V, time: T) -> V {
    lerp(from, to, time)
}

@inlinable
public func inverseLerp<T: FloatingPoint>(_ from: T, _ to: T, _ value: T) -> T {
    (value - from) / (to - from)
}

@inlinable
public func inverseLerp<T: FloatingPoint>(from: T, to: T, value: T) -> T {
    inverseLerp(from, to, value)
}

@inlinable
public func lerp<T: BinaryFloatingPoint>(_ from: CGPoint, _ to: CGPoint, _ time: T) -> CGPoint {
    CGPoint(
        x: lerp(from.x, to.x, time),
        y: lerp(from.y, to.y, time)
    )
}

@inlinable
public func lerp<T: BinaryFloatingPoint>(_ from: CGSize, _ to: CGSize, _ time: T) -> CGSize {
    CGSize(
        width: lerp(from.width, to.width, time),
        height: lerp(from.height, to.height, time)
    )
}

