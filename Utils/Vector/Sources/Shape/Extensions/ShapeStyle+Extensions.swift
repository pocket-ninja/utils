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
        case let .color(color): return color
        case let .gradient(gradient): return gradient.stops.first?.color
        }
    }

        #warning("FIX")
//    init(from shape: Macaw.Shape) {
//        self.init(
//            fill: ShapeFill(with: shape.fill),
//            stroke: ShapeStroke(with: shape.stroke)
//        )
//    }

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

        #warning("FIX")
//    init(with stroke: Macaw.Stroke?) {
//        self.init(
//            lineJoin: stroke.flatMap { $0.join.toCG() } ?? .round,
//            lineCap: stroke.flatMap { $0.cap.toCG() } ?? .round,
//            lineWidth: stroke.flatMap { CGFloat($0.width) } ?? 0,
//            color: stroke.flatMap { ($0.fill as? Color)?.toCG() } ?? UIColor.clear.cgColor
//        )
//    }

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
        #warning("FIX")
//    init(with fill: Macaw.Fill?) {
//        switch fill {
//        case let c as Macaw.Color:
//            self = .color(c.toCG())
//        case let g as RadialGradient:
//            self = .gradient(Gradient(radial: g))
//        case let g as Macaw.LinearGradient:
//            self = .gradient(Gradient(linear: g))
//        default:
//            self = .color(UIColor.clear.cgColor)
//        }
//    }

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
