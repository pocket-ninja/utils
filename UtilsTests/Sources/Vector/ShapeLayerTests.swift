//
//  Copyright © 2025 sroik. All rights reserved.
//

import Testing
import UIKit
import SnapshotTesting
import Vector

@MainActor
@Suite(.snapshots(record: .missing, diffTool: .ksdiff))
struct ShapeLayerTests {

    let container = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    init() {
        container.backgroundColor = .white
    }
    
    @Test func testColorFill() {
        let layer = ShapeLayer(shape: .stub())
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }

    @Test func testLinearGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape)
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }

    @Test func testRadialGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape)
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }

    @Test func testTranslatedLinearGradientFill() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape.translated(by: CGPoint(x: 50, y: 50)))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testTranslatedRadialGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape.translated(by: CGPoint(x: 50, y: 50)))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testScaledLinearGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .linearGradientStub))
        let layer = ShapeLayer(shape: shape.scaled(by: 2.0))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }

    @Test func testScaledRadialGradient() {
        let shape = Shape.stub(path: .arrowStub, style: .stub(fill: .radialGradientStub))
        let layer = ShapeLayer(shape: shape.scaled(by: 2.0))
        container.layer.addSublayer(layer)
        layer.frame = container.bounds
        assertSnapshot(of: container, as: .image)
    }
}
