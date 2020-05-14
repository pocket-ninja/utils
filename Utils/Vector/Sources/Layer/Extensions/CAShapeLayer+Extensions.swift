//
//  Created by sroik on 9/28/18.
//

import UIKit

public extension CAShapeLayer {
    static func clean() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = nil
        return layer
    }

    static func with(path: CGPath) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = path
        return layer
    }

    func setup(with shape: Shape) {
        path = shape.path
        lineWidth = shape.style.stroke.lineWidth
        lineCap = shape.style.stroke.lineCap.caLineCap
        lineJoin = shape.style.stroke.lineJoin.caLineJoin
        fillColor = shape.style.fill.color
        strokeColor = shape.style.stroke.color
    }
}

extension CGLineCap {
    var caLineCap: CAShapeLayerLineCap {
        switch self {
        case .butt: return .butt
        case .round: return .round
        case .square: return .square
        @unknown default: return .round
        }
    }
}

extension CGLineJoin {
    var caLineJoin: CAShapeLayerLineJoin {
        switch self {
        case .bevel: return .bevel
        case .miter: return .miter
        case .round: return .round
        @unknown default: return .round
        }
    }
}
