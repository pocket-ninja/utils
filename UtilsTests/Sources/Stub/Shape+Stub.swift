//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore
import Vector

extension Shape {
    static func stub(path: CGPath = .arrowStub, style: ShapeStyle = .stub()) -> Shape {
        return Shape(id: 0, path: path, style: style)
    }
}

extension ShapeStyle {
    static func stub(
        fill: ShapeFill = .colorStub,
        stroke: ShapeStroke = .stub()
    ) -> ShapeStyle {
        return ShapeStyle(fill: fill, stroke: stroke)
    }
}

extension ShapeFill {
    static var colorStub: ShapeFill {
        return ShapeFill.color(UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1).cgColor)
    }

    static var radialGradientStub: ShapeFill {
        return ShapeFill.gradient(Gradient(
            type: .radial(center: CGPoint(x: 0.5, y: 0.5), focal: CGPoint(x: 0.5, y: 0.5), radius: 0.35),
            stops: GradientStop.stubs,
            units: .boundingBox
        ))
    }

    static var linearGradientStub: ShapeFill {
        return ShapeFill.gradient(Gradient(
            type: .linear(start: CGPoint(x: 10, y: 10), end: CGPoint(x: 100, y: 100)),
            stops: GradientStop.stubs,
            units: .userSpace
        ))
    }
}

extension ShapeStroke {
    static func stub(lineWidth: CGFloat = 1.0, color: UIColor = .brown) -> ShapeStroke {
        return ShapeStroke(
            lineJoin: .bevel,
            lineCap: .round,
            lineWidth: lineWidth,
            color: color.cgColor
        )
    }
}

extension GradientStop {
    static var stubs: [GradientStop] {
        return [
            GradientStop(offset: 0.0, color: UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor),
            GradientStop(offset: 0.5, color: UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor),
            GradientStop(offset: 1.0, color: UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor)
        ]
    }
}
