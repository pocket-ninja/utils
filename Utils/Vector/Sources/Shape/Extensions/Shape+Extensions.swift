//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

public extension Shape {
    var bounds: CGRect {
        return path.boundingBox
    }

    func with(strokeScale: CGFloat) -> Shape {
        return with(strokeWidth: style.stroke.lineWidth * strokeScale)
    }

    func with(strokeWidth: CGFloat? = nil, strokeColor: CGColor? = nil) -> Shape {
        var style = self.style
        style.stroke.lineWidth = strokeWidth ?? self.style.stroke.lineWidth
        style.stroke.color = strokeColor ?? self.style.stroke.color
        return with(style: style)
    }

    func with(
        path: CGPath? = nil,
        style: ShapeStyle? = nil
    ) -> Shape {
        return Shape(
            identifier: identifier,
            index: index,
            path: path ?? self.path,
            style: style ?? self.style
        )
    }

    func translated(by translation: CGPoint) -> Shape {
        return Shape(
            identifier: identifier,
            index: index,
            path: path.translated(by: translation),
            style: style.translated(by: translation)
        )
    }

    func scaled(by scale: CGFloat) -> Shape {
        return Shape(
            identifier: identifier,
            index: index,
            path: path.scaled(by: scale),
            style: style.scaled(by: scale)
        )
    }

    func transform(toFit rect: CGRect) -> CGAffineTransform {
        let scale = bounds.size.scale(toFit: rect.size)
        let box = bounds.fitted(in: rect)
        let translation = box.origin - bounds.origin * scale
        let transform = CGAffineTransform(scaleX: scale, y: scale).translated(by: translation)
        return transform
    }
}

public extension Shape {
    static var empty: Shape {
        return Shape(
            identifier: 0,
            index: 0,
            path: CGPath(rect: .zero, transform: nil),
            style: .empty
        )
    }
}
