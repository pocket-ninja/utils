//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public struct Size<T: Measurable>: Hashable, Codable {
    public var width: T
    public var height: T

    public var cgSize: CGSize {
        return CGSize(width: width.doubleValue, height: height.doubleValue)
    }

    public init(width: T, height: T) {
        self.width = max(T(doubleValue: 0), width)
        self.height = max(T(doubleValue: 0), height)
    }

    public init(cgSize: CGSize) {
        self.width = T(doubleValue: Double(cgSize.width))
        self.height = T(doubleValue: Double(cgSize.height))
    }
}

extension Size {
    public static var zero: Size {
        return Size(cgSize: .zero)
    }

    public static func == (lhs: Size<T>, rhs: Size<T>) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }

    public static func * (l: Size<T>, by: T) -> Size<T> {
        return Size(width: l.width * by, height: l.height * by)
    }

    @available(*, deprecated, message: "use '*' operator")
    public func scaled(by: T) -> Size<T> {
        return self * by
    }
}

public protocol Measurable: Hashable, Comparable, Codable {
    var doubleValue: Double { get }
    init(doubleValue: Double)
}

extension Measurable {
    public static func * (lhs: Self, rhs: Self) -> Self {
        return Self(doubleValue: lhs.doubleValue * rhs.doubleValue)
    }
}

extension Int: Measurable {
    public var doubleValue: Double { return Double(self) }
    public init(doubleValue: Double) { self.init(doubleValue) }
}

extension Double: Measurable {
    public var doubleValue: Double { return self }
    public init(doubleValue: Double) { self.init(doubleValue) }
}

extension CGFloat: Measurable {
    public var doubleValue: Double { return Double(self) }
    public init(doubleValue: Double) { self.init(doubleValue) }
}

extension Float: Measurable {
    public var doubleValue: Double { return Double(self) }
    public init(doubleValue: Double) { self.init(doubleValue) }
}
