//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import UtilsCore

class CGPathPolygonizationTests: XCTestCase {

    var container: ShapeContainer!

    override func setUp() {
        super.setUp()
        container = ShapeContainer()
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    func testTriangle() {
        container.shapePath = CGPath.triangleStub.polygonized()
        assertSnapshot(matching: container, as: .image)
    }

    func testEllipseLowAccuracy() {
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 100, height: 75), transform: nil)
        container.shapePath = path.polygonized(accuracy: .low)
        assertSnapshot(matching: container, as: .image)
    }

    func testEllipseHighAccuracy() {
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 100, height: 75), transform: nil)
        container.shapePath = path.polygonized(accuracy: .high)
        assertSnapshot(matching: container, as: .image)
    }

    func testCubicShapeMediumAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addCurve(
            to: CGPoint(x: 200, y: 0),
            control1: CGPoint(x: 50, y: 300),
            control2: CGPoint(x: 150, y: 300)
        )
        path.closeSubpath()

        container.shapePath = path.polygonized(accuracy: .medium)
        assertSnapshot(matching: container, as: .image)
    }

    func testQuadShapeLowAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: 200, y: 0), control: CGPoint(x: 100, y: 200))
        path.closeSubpath()
        container.shapePath = path.polygonized(accuracy: .low)
        assertSnapshot(matching: container, as: .image)
    }

    func testQuadShapeHighAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: 200, y: 0), control: CGPoint(x: 100, y: 200))
        path.closeSubpath()
        container.shapePath = path.polygonized(accuracy: .high)
        assertSnapshot(matching: container, as: .image)
    }
}
