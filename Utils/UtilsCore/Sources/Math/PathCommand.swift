//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics

public enum PathCommand {
    case move(to: CGPoint)
    case line(to: CGPoint)
    case quadCurve(from: CGPoint, to: CGPoint)
    case curve(from: CGPoint, through: CGPoint, to: CGPoint)
    case close

    public var points: [CGPoint] {
        switch self {
        case let .quadCurve(cp1, cp2): return [cp1, cp2]
        case let .curve(cp1, cp2, cp3): return [cp1, cp2, cp3]
        case let .move(point): return [point]
        case let .line(point): return [point]
        case .close: return []
        }
    }

    public var point: CGPoint? {
        switch self {
        case let .quadCurve(point, _): return point
        case let .curve(point, _, _): return point
        case let .move(point): return point
        case let .line(point): return point
        case .close: return nil
        }
    }

    public func apply(to path: CGMutablePath) {
        switch self {
        case let .quadCurve(p, cp): path.addQuadCurve(to: p, control: cp)
        case let .curve(p, cp2, cp3): path.addCurve(to: p, control1: cp2, control2: cp3)
        case let .move(point): path.move(to: point)
        case let .line(point): path.addLine(to: point)
        case .close: path.closeSubpath()
        }
    }
}

public extension CGPathElement {
    var command: PathCommand {
        switch type {
        case .moveToPoint: return .move(to: points[0])
        case .addLineToPoint: return .line(to: points[0])
        case .addQuadCurveToPoint: return .quadCurve(from: points[0], to: points[1])
        case .addCurveToPoint: return .curve(from: points[0], through: points[1], to: points[2])
        case .closeSubpath: return .close
        @unknown default: return .close
        }
    }
}

extension PathCommand: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, points
    }

    private enum Base: String, Codable {
        case move, line, quadCurve, curve, close
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        let points = try container.decode([CGPoint].self, forKey: .points)

        switch base {
        case .move:
            self = .move(to: try points[safe: 0].get())
        case .line:
            self = .line(to: try points[safe: 0].get())
        case .close:
            self = .close
        case .quadCurve:
            self = .quadCurve(
                from: try points[safe: 0].get(),
                to: try points[safe: 1].get()
            )
        case .curve:
            self = .curve(
                from: try points[safe: 0].get(),
                through: try points[safe: 1].get(),
                to: try points[safe: 2].get()
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)

        switch self {
        case .quadCurve: try container.encode(Base.quadCurve, forKey: .base)
        case .curve: try container.encode(Base.curve, forKey: .base)
        case .move: try container.encode(Base.move, forKey: .base)
        case .line: try container.encode(Base.line, forKey: .base)
        case .close: try container.encode(Base.close, forKey: .base)
        }
    }
}
