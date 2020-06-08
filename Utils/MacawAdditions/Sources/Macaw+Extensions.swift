//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import Macaw
import Vector

public extension Vector.Shape {
    init(
        id: Int = 0,
        shape: Macaw.Shape,
        transform: CGAffineTransform = .identity,
        opacity: CGFloat = 1.0
    ) {
        let path = shape.form.toCGPath().transformed(with: shape.place.toCG())
        let transformedPath = path.transformed(with: transform)
        
        self.init(
            id: id,
            path: transformedPath,
            style: Vector.ShapeStyle(from: shape, opacity: opacity)
        )
    }
}

public extension ShapeStyle {
    init(from shape: Macaw.Shape, opacity: CGFloat) {
        self.init(
            fill: ShapeFill(
                with: shape.fill,
                opacity: opacity * CGFloat(shape.opacity)
            ),
            stroke: ShapeStroke(
                with: shape.stroke,
                opacity: opacity * CGFloat(shape.opacity)
            )
        )
    }
}

public extension ShapeStroke {
    init(with stroke: Macaw.Stroke?, opacity: CGFloat) {
        let color = stroke.flatMap { ($0.fill as? Color)?.toCG() } ?? UIColor.clear.cgColor
        self.init(
            lineJoin: stroke.flatMap { $0.join.toCG() } ?? .round,
            lineCap: stroke.flatMap { $0.cap.toCG() } ?? .round,
            lineWidth: stroke.flatMap { CGFloat($0.width) } ?? 0,
            color: color.multiplyingAlpha(by: opacity)
        )
    }
}

public extension ShapeFill {
    init(with fill: Macaw.Fill?, opacity: CGFloat) {
        switch fill {
        case let c as Macaw.Color:
            self = .color(c.toCG().multiplyingAlpha(by: opacity))
        case let g as RadialGradient:
            self = .gradient(Vector.Gradient(radial: g, opacity: opacity))
        case let g as Macaw.LinearGradient:
            self = .gradient(Vector.Gradient(linear: g, opacity: opacity))
        default:
            self = .color(UIColor.clear.cgColor)
        }
    }
}

public extension Vector.Gradient {
    init(linear: Macaw.LinearGradient, opacity: CGFloat) {
        let type = GradientType.linear(
            start: CGPoint(x: linear.x1, y: linear.y1),
            end: CGPoint(x: linear.x2, y: linear.y2)
        )

        self = .init(
            type: type,
            stops: linear.stops.map { GradientStop(with: $0, opacity: opacity) },
            units: linear.userSpace ? .userSpace : .boundingBox
        )
    }

    init(radial: Macaw.RadialGradient, opacity: CGFloat) {
        let type = GradientType.radial(
            center: CGPoint(x: radial.cx, y: radial.cy),
            focal: CGPoint(x: radial.fx, y: radial.fy),
            radius: CGFloat(radial.r)
        )

        self = .init(
            type: type,
            stops: radial.stops.map { GradientStop(with: $0, opacity: opacity) },
            units: radial.userSpace ? .userSpace : .boundingBox
        )
    }
}

public extension Vector.GradientStop {
    init(with stop: Macaw.Stop, opacity: CGFloat) {
        self.init(
            offset: CGFloat(stop.offset),
            color: stop.color.toCG().multiplyingAlpha(by: opacity)
        )
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

    var recursiveChildShapes: [Vector.Shape] {
        return recursiveChildShapes(
            transform: place.toCG(),
            opacity: CGFloat(opacity)
        )
    }
    
    func recursiveChildShapes(transform: CGAffineTransform, opacity: CGFloat) -> [Vector.Shape] {
        switch self {
        case let group as Macaw.Group:
            return group.contents.flatMap { (node: Macaw.Node) -> [Vector.Shape] in
                let groupTransform = group.place.toCG().concatenating(transform)
                let groupOpacity = CGFloat(group.opacity) * opacity
                return node.recursiveChildShapes(transform: groupTransform, opacity: groupOpacity)
            }

        case let macawShape as Macaw.Shape:
            let shape = Shape(shape: macawShape, transform: transform, opacity: opacity)
            return [shape]
        
        default:
            return []
        }
    }
    
    var recursiveMacawChildShapes: [Macaw.Shape] {
           switch self {
           case let group as Macaw.Group:
               return group.contents.flatMap { node in
                   node.recursiveMacawChildShapes
               }

           case let shape as Macaw.Shape:
               return [shape]

           default:
               return []
           }
       }
}

private extension CGColor {
    func multiplyingAlpha(by coeff: CGFloat) -> CGColor {
        return copy(alpha: alpha * coeff) ?? self
    }
}
