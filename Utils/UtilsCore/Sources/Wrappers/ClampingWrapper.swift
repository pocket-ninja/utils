//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Clamping<Value: Comparable> {
    public var value: Value
    let range: ClosedRange<Value>

    public init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

extension Clamping: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

extension Clamping: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}
