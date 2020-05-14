//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import Macaw
import Vector

public extension Vector.Shape {
    init(identifier: Vector.ShapeIdentifier, index: Int, shape: Macaw.Shape) {
        self.init(
            identifier: identifier,
            index: index,
            path: shape.form.toCGPath(),
            style: Vector.ShapeStyle(from: shape)
        )
    }
}

public extension ShapeStyle {
    init(from shape: Macaw.Shape) {
        self.init(
            fill: ShapeFill(with: shape.fill),
            stroke: ShapeStroke(with: shape.stroke)
        )
    }
}

public extension ShapeStroke {
    init(with stroke: Macaw.Stroke?) {
        self.init(
            lineJoin: stroke.flatMap { $0.join.toCG() } ?? .round,
            lineCap: stroke.flatMap { $0.cap.toCG() } ?? .round,
            lineWidth: stroke.flatMap { CGFloat($0.width) } ?? 0,
            color: stroke.flatMap { ($0.fill as? Color)?.toCG() } ?? UIColor.clear.cgColor
        )
    }
}

public extension ShapeFill {
    init(with fill: Macaw.Fill?) {
        switch fill {
        case let c as Macaw.Color:
            self = .color(c.toCG())
        case let g as RadialGradient:
            self = .gradient(Vector.Gradient(radial: g))
        case let g as Macaw.LinearGradient:
            self = .gradient(Vector.Gradient(linear: g))
        default:
            self = .color(UIColor.clear.cgColor)
        }
    }
}

public extension Vector.Gradient {
    init(linear: Macaw.LinearGradient) {
        let type = GradientType.linear(
            start: CGPoint(x: linear.x1, y: linear.y1),
            end: CGPoint(x: linear.x2, y: linear.y2)
        )

        self = .init(
            type: type,
            stops: linear.stops.map(GradientStop.init),
            units: linear.userSpace ? .userSpace : .boundingBox
        )
    }

    init(radial: Macaw.RadialGradient) {
        let type = GradientType.radial(
            center: CGPoint(x: radial.cx, y: radial.cy),
            focal: CGPoint(x: radial.fx, y: radial.fy),
            radius: CGFloat(radial.r)
        )

        self = .init(
            type: type,
            stops: radial.stops.map(GradientStop.init),
            units: radial.userSpace ? .userSpace : .boundingBox
        )
    }
}

public extension Vector.GradientStop {
    init(with stop: Macaw.Stop) {
        self.init(offset: CGFloat(stop.offset), color: stop.color.toCG())
    }
}

public extension Macaw.Node {
    typealias Predicate = (Vector.Shape) -> Bool

    var viewBox: CGRect? {
        guard
            let canvas = self as? Macaw.SVGCanvas,
            let boxSize = canvas.layout.viewBox?.toCG()
        else {
            return nil
        }

        return boxSize
    }

    var childShapes: [Vector.Shape] {
        return macawChildShapes.enumerated().map {
            let index = $0.offset + 1
            return Shape(identifier: index, index: index, shape: $0.element)
        }
    }

    func childShapes(withPredicate predicate: Predicate) -> [Vector.Shape] {
        var index: Int = 1

        return macawChildShapes.enumerated().compactMap {
            let shape = Vector.Shape(identifier: index, index: index, shape: $0.element)

            guard predicate(shape) else {
                return nil
            }

            index += 1
            return shape
        }
    }
    
    var macawChildShapes: [Macaw.Shape] {
        switch self {
        case let group as Macaw.Group:
            return group.contents.flatMap { node in
                node.macawChildShapes
            }

        case let shape as Macaw.Shape:
            return [shape]

        default:
            return []
        }
    }
}
