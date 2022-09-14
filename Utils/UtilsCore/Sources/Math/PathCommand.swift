//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics

public enum PathCommand: Equatable {
    case move(to: CGPoint)
    case line(to: CGPoint)
    case quadCurve(cp: CGPoint, to: CGPoint)
    case curve(cp1: CGPoint, cp2: CGPoint, to: CGPoint)
    case close

    public var point: CGPoint? {
        switch self {
        case let .quadCurve(_, to): return to
        case let .curve(_, _, to): return to
        case let .move(to): return to
        case let .line(to): return to
        case .close: return nil
        }
    }

    public var points: [CGPoint] {
        switch self {
        case let .quadCurve(cp, to): return [cp, to]
        case let .curve(cp1, cp2, to): return [cp1, cp2, to]
        case let .move(point): return [point]
        case let .line(point): return [point]
        case .close: return []
        }
    }

    public func apply(to path: CGMutablePath) {
        switch self {
        case let .quadCurve(cp, to): path.addQuadCurve(to: to, control: cp)
        case let .curve(cp1, cp2, to): path.addCurve(to: to, control1: cp1, control2: cp2)
        case let .move(point): path.move(to: point)
        case let .line(point): path.addLine(to: point)
        case .close: path.closeSubpath()
        }
    }
}

extension CGPathElement {
    var command: PathCommand {
        switch type {
        case .moveToPoint: return .move(to: points[0])
        case .addLineToPoint: return .line(to: points[0])
        case .addQuadCurveToPoint: return .quadCurve(cp: points[0], to: points[1])
        case .addCurveToPoint: return .curve(cp1: points[0], cp2: points[1], to: points[2])
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
                cp: try points[safe: 0].get(),
                to: try points[safe: 1].get()
            )
        case .curve:
            self = .curve(
                cp1: try points[safe: 0].get(),
                cp2: try points[safe: 1].get(),
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
