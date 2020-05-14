//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

public class ShapesLayer: CALayer {
    public var shapes: [Shape]
    public var size: CGSize
    
    public var shapeLayers: [ShapeLayer] {
        return Array(layers.values)
    }

    public var layersFrame: CGRect {
        return CGRect(size: size).centered(in: bounds, rounded: false)
    }

    public var layersTransform: CGAffineTransform {
        let scale = size.scale(toFit: bounds.size)
        return CGAffineTransform(scaleX: scale, y: scale)
    }
    
    public init(shapes: [Shape], size: CGSize) {
        self.shapes = shapes
        self.size = size
        super.init()
        render()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(shapes: [], size: .zero)
    }

    override init(layer: Any) {
        self.size = .zero
        self.shapes = []
        super.init(layer: layer)
    }
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        if !bounds.isEmpty {
            shapeLayers.forEach(layout)
        }
    }
    
    public func layer(of shape: Shape) -> ShapeLayer? {
        return layers[shape]
    }
    
    public func render() {
        layers.values.forEach { $0.removeFromSuperlayer() }
        layers = [:]

        shapes.forEach { shape in
            let layer = ShapeLayer(shape: shape)
            addSublayer(layer)
            layout(layer: layer)
            layers[shape] = layer
        }
    }
    
    private func layout(layer: ShapeLayer) {
        layer.transform = CATransform3DIdentity
        layer.frame = layersFrame
        layer.transform = layersTransform.caTransform
    }
    
    private var layers: [Shape: ShapeLayer] = [:]
}
