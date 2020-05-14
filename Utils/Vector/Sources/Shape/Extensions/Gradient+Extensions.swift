//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

public extension Gradient {
        #warning("FIX")
//    init(linear: Macaw.LinearGradient) {
//        let type = GradientType.linear(
//            start: CGPoint(x: linear.x1, y: linear.y1),
//            end: CGPoint(x: linear.x2, y: linear.y2)
//        )
//
//        self = Gradient(
//            type: type,
//            stops: linear.stops.map(GradientStop.init),
//            units: linear.userSpace ? .userSpace : .boundingBox
//        )
//    }
//
//    init(radial: Macaw.RadialGradient) {
//        let type = GradientType.radial(
//            center: CGPoint(x: radial.cx, y: radial.cy),
//            focal: CGPoint(x: radial.fx, y: radial.fy),
//            radius: CGFloat(radial.r)
//        )
//
//        self = Gradient(
//            type: type,
//            stops: radial.stops.map(GradientStop.init),
//            units: radial.userSpace ? .userSpace : .boundingBox
//        )
//    }

    func scaled(by scale: CGFloat) -> Gradient {
        switch units {
        case .userSpace:
            return Gradient(type: type.scaled(by: scale), stops: stops, units: units)
        case .boundingBox:
            return self
        }
    }

    func translated(by: CGPoint) -> Gradient {
        switch units {
        case .userSpace:
            return Gradient(type: type.translated(by: by), stops: stops, units: units)
        case .boundingBox:
            return self
        }
    }
}

public extension GradientStop {
        #warning("FIX")
//    init(with stop: Macaw.Stop) {
//        self.init(offset: CGFloat(stop.offset), color: stop.color.toCG())
//    }
}

public extension GradientUnits {
    func userSpace(point: CGPoint, in contextBounds: CGRect) -> CGPoint {
        switch self {
        case .userSpace: return point
        case .boundingBox: return point.absolute(in: contextBounds)
        }
    }

    func userSpace(radius: CGFloat, in contextBounds: CGRect) -> CGFloat {
        switch self {
        case .userSpace: return radius
        case .boundingBox: return radius.absolute(in: contextBounds)
        }
    }
}

public extension GradientType {
    var caType: CAGradientLayerType {
        switch self {
        case .linear: return .axial
        case .radial: return .radial
        }
    }

    func scaled(by scale: CGFloat) -> GradientType {
        switch self {
        case let .linear(s, e):
            return .linear(start: s * scale, end: e * scale)
        case let .radial(c, f, r):
            return .radial(center: c * scale, focal: f * scale, radius: r * scale)
        }
    }

    func translated(by: CGPoint) -> GradientType {
        switch self {
        case let .linear(s, e):
            return .linear(start: s + by, end: e + by)
        case let .radial(c, f, r):
            return .radial(center: c + by, focal: f + by, radius: r)
        }
    }
}
