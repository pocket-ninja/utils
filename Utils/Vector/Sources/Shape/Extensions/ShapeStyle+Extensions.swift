//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension ShapeStyle {
    static var empty: ShapeStyle {
        return ShapeStyle(
            fill: .color(UIColor.clear.cgColor),
            stroke: .empty
        )
    }

    var accentColor: CGColor? {
        switch fill {
        case let .color(color):
            return color
        case let .gradient(gradient):
            return gradient.stops.first?.color
        }
    }
    
    func scaled(by scale: CGFloat) -> ShapeStyle {
        return ShapeStyle(
            fill: fill.scaled(by: scale),
            stroke: stroke.scaled(by: scale)
        )
    }

    func translated(by translation: CGPoint) -> ShapeStyle {
        return ShapeStyle(
            fill: fill.translated(by: translation),
            stroke: stroke
        )
    }
}

public extension ShapeStroke {
    static var empty: ShapeStroke {
        return ShapeStroke(
            lineJoin: .round,
            lineCap: .round,
            lineWidth: 0,
            color: UIColor.clear.cgColor
        )
    }

    func scaled(by scale: CGFloat) -> ShapeStroke {
        return ShapeStroke(
            lineJoin: lineJoin,
            lineCap: lineCap,
            lineWidth: lineWidth * scale,
            color: color
        )
    }
}

public extension ShapeFill {
    var colors: [CGColor] {
        switch self {
        case let .color(color):
            return [color]
        case let .gradient(gradient):
            return gradient.stops.map { $0.color }
        }
    }

    var color: CGColor? {
        switch self {
        case let .color(color): return color
        case .gradient: return nil
        }
    }

    var gradient: Gradient? {
        switch self {
        case .color: return nil
        case let .gradient(gradient): return gradient
        }
    }

    func scaled(by scale: CGFloat) -> ShapeFill {
        switch self {
        case .color: return self
        case let .gradient(g): return .gradient(g.scaled(by: scale))
        }
    }

    func translated(by translation: CGPoint) -> ShapeFill {
        switch self {
        case .color: return self
        case let .gradient(g): return .gradient(g.translated(by: translation))
        }
    }
}
