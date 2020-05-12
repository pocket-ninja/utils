//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

class ShapeContainer: UIView {

    let shape: CAShapeLayer

    var shapePath: CGPath {
        didSet {
            shape.path = shapePath
            shape.position = CGPoint(x: -insets, y: -insets)
            frame = shapePath.boundingBox.insetBy(dx: insets, dy: insets)
        }
    }

    init(shape: CAShapeLayer, path: CGPath = CGPath.along(points: [], closed: true)) {
        self.shape = shape
        self.shapePath = path
        super.init(frame: .zero)

        layer.addSublayer(shape)
        backgroundColor = .white
    }

    convenience init() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1

        self.init(shape: shapeLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private let insets: CGFloat = -10
}
