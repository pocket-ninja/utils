//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics


/* All names are taken from https://en.wikipedia.org/wiki/Line_(geometry) */
public enum Line: Hashable {
    /* vertical line with position in x-axis */
    case vertical(x: CGFloat)

    /* the slope (or gradient) and y-intercept (position in the y-axis) of the line */
    case sloped(slope: CGFloat, intercept: CGFloat)
}

public extension Line {
    var isHorizontal: Bool {
        switch self {
        case .vertical: return false
        case let .sloped(slope, _): return slope < .ulpOfOne
        }
    }

    init(a: CGPoint, b: CGPoint) {
        let delta = a - b

        guard delta.x != 0 else {
            self = .vertical(x: a.x)
            return
        }

        let slope = delta.y / delta.x
        self = .sloped(slope: slope, intercept: -slope * a.x + a.y)
    }

    init(segment: LineSegment) {
        self.init(a: segment.a, b: segment.b)
    }

    subscript(x x: CGFloat) -> CGPoint? {
        switch self {
        case .vertical:
            return nil
        case let .sloped(slope, intercept):
            return CGPoint(x: x, y: slope * x + intercept)
        }
    }

    subscript(y y: CGFloat) -> CGPoint? {
        switch self {
        case let .vertical(x):
            return CGPoint(x: x, y: y)
        case .sloped where isHorizontal:
            return nil
        case let .sloped(slope, intercept):
            return CGPoint(x: (y - intercept) / slope, y: y)
        }
    }

    func contains(_ point: CGPoint) -> Bool {
        switch self {
        case let .vertical(x):
            return point.x == x
        case .sloped:
            guard let nearest = self[x: point.x] else {
                return false
            }

            return nearest.distance(to: point) <= .ulpOfOne
        }
    }

    func isParallel(to line: Line, threshold: CGFloat = .ulpOfOne) -> Bool {
        switch (self, line) {
        case (.vertical, .vertical):
            return true
        case (.vertical, .sloped), (.sloped, .vertical):
            return false
        case let (.sloped(s1, _), .sloped(s2, _)):
            return abs(s1 - s2) < threshold
        }
    }

    func intersection(with line: Line) -> CGPoint? {
        switch (self, line) {
        case let (.vertical(x), .sloped):
            return line[x: x]
        case let (.sloped, .vertical(x)):
            return self[x: x]
        case (.vertical, .vertical):
            return nil
        case (.sloped, .sloped) where isParallel(to: line):
            return nil
        case let (.sloped(s1, i1), .sloped(s2, i2)):
            return self[x: (i2 - i1) / (s1 - s2)]
        }
    }
}
