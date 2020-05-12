//
//  Copyright © 2020 sroik. All rights reserved.
//

import CoreGraphics

public extension CGPath {
    static func along(points: [CGPoint], closed: Bool) -> CGPath {
        let path = CGMutablePath()
        points.first.apply { path.move(to: $0) }
        points.dropFirst().forEach { path.addLine(to: $0) }
        closed.onTrue { path.closeSubpath() }
        return path
    }

    static func with(commands: [PathCommand]) -> CGPath {
        let path = CGMutablePath()
        commands.forEach { $0.apply(to: path) }
        return path
    }

    var points: [CGPoint] {
        return commands.flatMap { $0.points }
    }

    var commands: [PathCommand] {
        var commands: [PathCommand] = []
        enumerate { commands.append($0) }
        return commands
    }

    var subpathsCommands: [[PathCommand]] {
        var commands: [[PathCommand]] = []
        var subpathCommands: [PathCommand]?
        enumerate { command in
            switch command {
            case .line, .curve, .quadCurve:
                subpathCommands?.append(command)
            case .close:
                subpathCommands.apply { commands.append($0) }
                subpathCommands = nil
            case .move:
                subpathCommands = [command]
            }
        }
        return commands
    }

    var lineSegments: [LineSegment] {
        return LineSegment.from(commands: commands)
    }

    var centroid: CGPoint {
        return centroid()
    }

    var area: CGFloat {
        return area()
    }

    /*
     * polygon centroid: https://en.wikipedia.org/wiki/Centroid#Centroid_of_a_polygon
     * here is the a great article: http://paulbourke.net/geometry/polygonmesh/
     */
    func centroid(accuracy: PathPolygonizer.Accuracy = .medium) -> CGPoint {
        /* let's assign area to the property to reduce computational complexity */
        let area = signedArea(accuracy: accuracy)

        guard !area.isZero, !area.isNaN else {
            assertionWrapperFailure("invalid path area")
            return .zero
        }

        let points = polygonized(accuracy: accuracy).points
        let centroid: CGPoint = points.indices.reduce(CGPoint.zero) { c, i in
            let j = (i + 1) % points.count
            let multiplier = points[i].x * points[j].y - points[i].y * points[j].x
            return c + (points[i] + points[j]) * multiplier
        }

        return centroid / (6.0 * area)
    }

    func area(accuracy: PathPolygonizer.Accuracy = .medium) -> CGFloat {
        return abs(signedArea(accuracy: accuracy))
    }

    /*
     * polygon area: https://en.wikipedia.org/wiki/Shoelace_formula
     * not works for self-intersecting polygons
     */
    func signedArea(accuracy: PathPolygonizer.Accuracy = .medium) -> CGFloat {
        let points = polygonized(accuracy: accuracy).points
        let area = points.indices.reduce(CGFloat(0)) { a, i in
            let j = (i + 1) % points.count
            return a + points[i].x * points[j].y - points[i].y * points[j].x
        }

        assertWrapper(!area.isNaN, "nan path area")
        return area / 2
    }

    func polygonized(accuracy: PathPolygonizer.Accuracy = .medium) -> CGPath {
        return PathPolygonizer(accuracy: accuracy).polygonize(path: self)
    }

    func scaled(by: CGFloat) -> CGPath {
        return transformed(with: CGAffineTransform(scaleX: by, y: by))
    }

    func translated(by: CGPoint) -> CGPath {
        return transformed(with: CGAffineTransform(translationX: by.x, y: by.y))
    }

    func transformed(with transform: CGAffineTransform) -> CGPath {
        var t = transform
        let path = copy(using: &t)
        return path ?? self
    }

    func enumerate(_ block: @escaping (PathCommand) -> Void) {
        enumerateElements { block($0.command) }
    }

    private func enumerateElements(_ body: @escaping Body) {
        func applier(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }

        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        apply(info: unsafeBody, function: applier)
    }

    private typealias Body = @convention(block) (CGPathElement) -> Void
}
