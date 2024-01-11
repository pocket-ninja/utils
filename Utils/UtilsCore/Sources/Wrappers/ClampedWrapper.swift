//
//  Copyright © 2024 sroik. All rights reserved.
//

import Foundation

@available(*, deprecated, renamed: "Clamped")
public typealias Clamping = Clamped

@propertyWrapper
public struct Clamped<Value: Comparable> {
    public var value: Value
    let range: ClosedRange<Value>

    public init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = value.clamped(in: range)
    }

    public var wrappedValue: Value {
        get { value }
        set { value = newValue.clamped(in: range) }
    }
}

extension Clamped: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension Clamped: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}
