//
//  Copyright © 2018 appcraft. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting
import Vector

class ShapeLayerTests: XCTestCase {

    var container: UIView!

    override func setUp() {
        super.setUp()
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        container.backgroundColor = .white
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    func testColorFill() {
        let layer = ShapeLayer(shape: .stub())
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }

    func testLinearGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape)
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }

    func testRadialGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape)
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }

    func testTranslatedLinearGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape.translated(by: CGPoint(x: 50, y: 50)))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }
    
    func testTranslatedRadialGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape.translated(by: CGPoint(x: 50, y: 50)))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }
    
    func testScaledLinearGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape.scaled(by: 2.0))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }

    func testScaledRadialGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape.scaled(by: 2.0))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(matching: container, as: .image)
    }
}
