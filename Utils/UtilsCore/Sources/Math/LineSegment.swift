//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics

public struct LineSegment: Hashable {
    public var a: CGPoint
    public var b: CGPoint

    public init(a: CGPoint, b: CGPoint) {
        self.a = a
        self.b = b
    }
}

public extension LineSegment {
    var length: CGFloat {
        return a.distance(to: b)
    }

    var slope: CGFloat {
        return a.x
    }

    var line: Line {
        return Line(segment: self)
    }

    func distance(to p: CGPoint) -> CGFloat {
        let length = self.length
        if length.isZero {
            return a.distance(to: p)
        }

        let delta = b - a
        let sqrLength = length * length
        let perpendicularPointRelation = ((p.x - a.x) * delta.x + (p.y - a.y) * delta.y) / sqrLength

        if perpendicularPointRelation < 0 {
            return a.distance(to: p)
        }

        if perpendicularPointRelation > 1 {
            return b.distance(to: p)
        }

        let perpendicularPoint = a + delta * perpendicularPointRelation
        return p.distance(to: perpendicularPoint)
    }

    func contains(_ point: CGPoint) -> Bool {
        return line.contains(point) &&
            point.x.between(a.x, b.x) &&
            point.y.between(a.y, b.y)
    }

    func intersection(with segment: LineSegment) -> CGPoint? {
        guard let intersection = line.intersection(with: segment.line) else {
            return nil
        }

        guard contains(intersection), segment.contains(intersection) else {
            return nil
        }

        return intersection
    }

    static func from(commands: [PathCommand]) -> [LineSegment] {
        var segments: [LineSegment] = []
        var subpathStart: CGPoint?
        var subpathEnd: CGPoint?

        for command in commands {
            switch command {
            case let .line(point):
                if let end = subpathEnd {
                    segments.append(LineSegment(a: end, b: point))
                    subpathEnd = point
                }

            case .close:
                if let end = subpathEnd, let start = subpathStart {
                    segments.append(LineSegment(a: end, b: start))
                }

            case .curve, .quadCurve:
                subpathEnd = command.point

            case .move:
                subpathEnd = command.point
                subpathStart = subpathEnd
            }
        }

        return segments
    }
}
