//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public class ShapeLayer: CALayer {
    public let shape: Shape
    public let shapeLayer = CAShapeLayer.clean()
    public let gradientLayer = CAGradientLayer()

    public init(shape: Shape) {
        self.shape = shape
        super.init()
        setup()
    }

    public override init(layer: Any) {
        shape = .empty
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public override func layoutSublayers() {
        super.layoutSublayers()
        let isFrameChanged = shapeLayer.frame.distance(to: bounds) > .layoutEpsilon
        if isFrameChanged {
            shapeLayer.frame = bounds
            gradientLayer.frame = bounds
            redraw()
        }
    }

    private func setup() {
        addSublayer(gradientLayer)
        addSublayer(shapeLayer)
    }

    private func redraw() {
        gradientLayer.setup(with: shape)
        shapeLayer.setup(with: shape)
    }
}
