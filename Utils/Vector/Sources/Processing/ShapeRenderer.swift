//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

public class ShapeRenderer {
    public struct Format {
        public var fills: Bool
        public var strokes: Bool
        
        public init(fills: Bool = true, strokes: Bool = true) {
            self.fills = fills
            self.strokes = strokes
        }
    }
    
    public init(format: Format = Format()) {
        self.format = format
    }
    
    public func render(_ shape: Shape) -> CGImage? {
        let size = shape.bounds.size * UIScreen.main.scale
        return render(shape, fitting: size)
    }

    public func render(
        _ shape: Shape,
        fitting size: CGSize,
        insets: UIEdgeInsets = .zero,
        preparesContext: Bool = true
    ) -> CGImage? {
        guard let ctx = CGContext.with(size: size) else {
            return nil
        }

        if preparesContext {
            ctx.prepareForDrawing()
        }
        
        render(shape, in: ctx, fitting: insets.inset(CGRect(size: size)))
        return ctx.makeImage()
    }

    public func render(_ shape: Shape, in ctx: CGContext, fitting rect: CGRect) {
        ctx.saveGState()
        defer { ctx.restoreGState() }
        ctx.concatenate(shape.transform(toFit: rect))
        render(shape, in: ctx)
    }

    public func render(_ shape: Shape, in ctx: CGContext) {
        ctx.saveGState()
        ctx.setStyle(shape.style)
        defer { ctx.restoreGState() }
        
        if format.fills {
            ctx.setPath(shape.path)
            switch shape.style.fill {
            case let .gradient(g): GradientRenderer.render(g, in: ctx)
            case .color: ctx.drawPath(using: .fill)
            }
        }
        
        if format.strokes {
            ctx.setPath(shape.path)
            ctx.drawPath(using: .stroke)
        }
    }
    
    private let format: Format
}

private extension CGContext {
    func setStyle(_ style: ShapeStyle) {
        setLineCap(style.stroke.lineCap)
        setLineJoin(style.stroke.lineJoin)
        setLineWidth(style.stroke.lineWidth / scale)
        setStrokeColor(style.stroke.color)
        style.fill.color.apply(setFillColor)
    }

    func setPath(_ path: CGPath) {
        beginPath()
        addPath(path)
    }
}
