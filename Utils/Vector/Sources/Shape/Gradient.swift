//
//  Copyright © 2020 sroik. All rights reserved.
//

import UtilsCore
import CoreGraphics

public enum GradientType: Hashable {
    case linear(start: CGPoint, end: CGPoint)
    case radial(center: CGPoint, focal: CGPoint, radius: CGFloat)
}

public struct GradientStop: Hashable {
    public let offset: CGFloat
    public let color: CGColor

    public init(offset: CGFloat, color: CGColor) {
        self.offset = offset
        self.color = color
    }
}

public enum GradientUnits: String, Codable {
    case userSpace
    case boundingBox
}

public struct Gradient: Hashable, Codable {
    public let type: GradientType
    public let stops: [GradientStop]
    public let units: GradientUnits

    public init(type: GradientType, stops: [GradientStop], units: GradientUnits) {
        self.type = type
        self.stops = stops
        self.units = units
    }
}
