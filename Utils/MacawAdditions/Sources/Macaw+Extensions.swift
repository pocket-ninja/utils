//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import Macaw
import Vector

public extension Vector.Shape {
    init(id: Int = 0, shape: Macaw.Shape, transform: CGAffineTransform = .identity) {
        let path = shape.form.toCGPath().transformed(with: shape.place.toCG())
        let transformedPath = path.transformed(with: transform)
        
        self.init(
            id: id,
            path: transformedPath,
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

    var recursiveChildShapes: [Vector.Shape] {
        return recursiveChildShapes(transform: place.toCG())
    }
    
    func recursiveChildShapes(transform: CGAffineTransform) -> [Vector.Shape] {
        switch self {
        case let group as Macaw.Group:
            return group.contents.flatMap { (node: Macaw.Node) -> [Vector.Shape] in
                let transform = group.place.toCG().concatenating(transform)
                return node.recursiveChildShapes(transform: transform)
            }

        case let macawShape as Macaw.Shape:
            let shape = Shape(shape: macawShape, transform: transform)
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
