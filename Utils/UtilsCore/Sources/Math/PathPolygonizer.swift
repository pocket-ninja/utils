//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics


public final class PathPolygonizer {
    public init(accuracy: Accuracy) {
        self.accuracy = accuracy
    }

    public func polygonize(path: CGPath) -> CGPath {
        var commands: [PathCommand] = []

        path.enumerate { cmd in
            switch cmd {
            case let .quadCurve(cp1, cp2):
                guard let lastPoint = commands.last?.point else { return }
                self.interpolateQuad(cp0: lastPoint, cp1: cp1, cp2: cp2).forEach {
                    commands.append(.line(to: $0))
                }

            case let .curve(cp1, cp2, cp3):
                guard let lastPoint = commands.last?.point else { return }
                self.interpolateCubic(cp0: lastPoint, cp1: cp1, cp2: cp2, cp3: cp3).forEach {
                    commands.append(.line(to: $0))
                }

            case .line, .move, .close:
                commands.append(cmd)
            }
        }

        return CGPath.with(commands: commands)
    }

    private func interpolateQuad(cp0: CGPoint, cp1: CGPoint, cp2: CGPoint) -> [CGPoint] {
        return QuadCurveInterpolator.interpolate(capacity: capacity, cp0: cp0, cp1: cp1, cp2: cp2)
    }

    private func interpolateCubic(cp0: CGPoint, cp1: CGPoint, cp2: CGPoint, cp3: CGPoint) -> [CGPoint] {
        return CubicCurveInterpolator.interpolate(capacity: capacity, cp0: cp0, cp1: cp1, cp2: cp2, cp3: cp3)
    }

    private var capacity: Int {
        return accuracy.capacity
    }

    private let accuracy: Accuracy
}

public extension PathPolygonizer {
    enum Accuracy {
        case low
        case medium
        case high
        case custom(capacity: Int)

        public var capacity: Int {
            switch self {
            case .low: return 3
            case .medium: return 10
            case .high: return 20
            case let .custom(capacity): return capacity
            }
        }
    }
}

/* https://en.wikipedia.org/wiki/B%C3%A9zier_curve#Quadratic_B%C3%A9zier_curves */
private final class QuadCurveInterpolator {
    static func interpolate(capacity: Int, cp0: CGPoint, cp1: CGPoint, cp2: CGPoint) -> [CGPoint] {
        return (0 ... capacity).map { index in
            let time = CGFloat(index) / CGFloat(capacity)
            return point(at: time, cp0: cp0, cp1: cp1, cp2: cp2)
        }
    }

    private static func point(at t: CGFloat, cp0: CGPoint, cp1: CGPoint, cp2: CGPoint) -> CGPoint {
        let mt = 1.0 - t
        let a = mt * mt
        let b = mt * t * 2
        let c = t * t

        let x = a * cp0.x + b * cp1.x + c * cp2.x
        let y = a * cp0.y + b * cp1.y + c * cp2.y
        return CGPoint(x: x, y: y)
    }
}

/* https://en.wikipedia.org/wiki/B%C3%A9zier_curve#Cubic_B%C3%A9zier_curves */
private final class CubicCurveInterpolator {
    static func interpolate(capacity: Int, cp0: CGPoint, cp1: CGPoint, cp2: CGPoint, cp3: CGPoint) -> [CGPoint] {
        return (0 ... capacity).map { index in
            let time = CGFloat(index) / CGFloat(capacity)
            return point(at: time, cp0: cp0, cp1: cp1, cp2: cp2, cp3: cp3)
        }
    }

    private static func point(at t: CGFloat, cp0: CGPoint, cp1: CGPoint, cp2: CGPoint, cp3: CGPoint) -> CGPoint {
        let mt = 1 - t
        let a = mt * mt * mt
        let b = mt * mt * t * 3
        let c = mt * t * t * 3
        let d = t * t * t

        let x = a * cp0.x + b * cp1.x + c * cp2.x + d * cp3.x
        let y = a * cp0.y + b * cp1.y + c * cp2.y + d * cp3.y
        return CGPoint(x: x, y: y)
    }
}
