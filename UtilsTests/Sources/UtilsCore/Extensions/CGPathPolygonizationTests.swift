//
//  Copyright © 2020 sroik. All rights reserved.
//

import Testing
import UIKit
import SnapshotTesting
@testable import UtilsCore

@MainActor
@Suite(.snapshots(record: .missing, diffTool: .ksdiff))
struct CGPathPolygonizationTests {
    let container = ShapeContainer()
    
    @Test func testTriangle() {
        container.shapePath = CGPath.triangleStub.polygonized()
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testEllipseLowAccuracy() {
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 100, height: 75), transform: nil)
        container.shapePath = path.polygonized(accuracy: .low)
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testEllipseHighAccuracy() {
        let path = CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 100, height: 75), transform: nil)
        container.shapePath = path.polygonized(accuracy: .high)
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testCubicShapeMediumAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addCurve(
            to: CGPoint(x: 200, y: 0),
            control1: CGPoint(x: 50, y: 300),
            control2: CGPoint(x: 150, y: 300)
        )
        path.closeSubpath()
        
        container.shapePath = path.polygonized(accuracy: .medium)
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testQuadShapeLowAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: 200, y: 0), control: CGPoint(x: 100, y: 200))
        path.closeSubpath()
        container.shapePath = path.polygonized(accuracy: .low)
        assertSnapshot(of: container, as: .image)
    }
    
    @Test func testQuadShapeHighAccuracy() {
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addQuadCurve(to: CGPoint(x: 200, y: 0), control: CGPoint(x: 100, y: 200))
        path.closeSubpath()
        container.shapePath = path.polygonized(accuracy: .high)
        assertSnapshot(of: container, as: .image)
    }
}
