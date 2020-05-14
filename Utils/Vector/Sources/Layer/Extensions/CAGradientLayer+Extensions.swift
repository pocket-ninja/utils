//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension CAGradientLayer {
    var absoluteStart: CGPoint {
        get {
            return startPoint.absolute(in: frame)
        }
        set {
            startPoint = newValue.related(in: frame)
        }
    }

    var absoluteEnd: CGPoint {
        get {
            return endPoint.absolute(in: frame)
        }
        set {
            endPoint = newValue.related(in: frame)
        }
    }

    func setup(with shape: Shape) {
        guard let gradient = shape.style.fill.gradient else {
            return
        }

        colors = gradient.stops.map { $0.color }
        locations = gradient.stops.map { NSNumber(value: Double($0.offset)) }
        type = gradient.type.caType
        mask = CAShapeLayer.with(path: shape.path)

        switch gradient.type {
        case let .linear(start, end):
            absoluteStart = gradient.units.userSpace(point: start, in: shape.bounds)
            absoluteEnd = gradient.units.userSpace(point: end, in: shape.bounds)

        case let .radial(center, _, radius):
            let end = CGPoint(x: center.x + radius, y: center.y + radius)
            absoluteStart = gradient.units.userSpace(point: center, in: shape.bounds)
            absoluteEnd = gradient.units.userSpace(point: end, in: shape.bounds)
        }
    }
}
