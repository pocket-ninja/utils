//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Percent: Hashable {
    public let value: CGFloat
    
    public init(value: CGFloat) {
        self.value = value.clamped(from: 0, to: 1)
    }

    public init(_ value: CGFloat) {
        self.init(value: value)
    }
}

extension Percent: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    public static var zero: Percent = 0

    public var inverted: Percent {
        return Percent(1 - value)
    }

    public init(floatLiteral value: FloatLiteralType) {
        self.init(CGFloat(value))
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(CGFloat(value))
    }

    public init(value: Double) {
        self.init(CGFloat(value))
    }

    public init(_ value: Double) {
        self.init(CGFloat(value))
    }

}
