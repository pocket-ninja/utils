//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import CoreGraphics
@testable import UtilsCore

class CGPathExtensionsTests: XCTestCase {

    func testTriangleArea() {
        let path = CGPath.along(points: [
            CGPoint(x: 5, y: 5),
            CGPoint(x: 10, y: 5),
            CGPoint(x: 15, y: 15)
        ], closed: true)

        XCTAssertEqual(path.area, (5 * 10) / 2)
    }

    func testRectArea() {
        let p1 = CGPath(rect: CGRect(x: -10, y: -20, width: 4, height: 5), transform: nil)
        XCTAssertEqual(p1.area, 20.0)
    }

    func testArrowArea() {
        let path = CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: -2, y: -6),
            CGPoint(x: -4, y: 0),
            CGPoint(x: -2, y: -3)
        ], closed: true)

        let bigA: CGFloat = (4 * 6) / 2
        let smallA: CGFloat = (4 * 3) / 2
        XCTAssertEqual(path.area, bigA - smallA)
    }

    func testNanArea() {
        let p2 = CGPath(rect: CGRect(x: 0, y: 0, width: CGFloat.nan, height: CGFloat.nan), transform: nil)
        XCTAssertEqual(p2.area, 0.0)
    }

    func testPoints() {
        let p0 = CGPoint(x: 0, y: 0)
        let p1 = CGPoint(x: 1, y: 0)
        let p2 = CGPoint(x: 1, y: 1)
        let p3 = CGPoint(x: 2, y: 0)
        let p4 = CGPoint(x: 2, y: 1)
        let p5 = CGPoint(x: 2, y: 2)
        let p6 = CGPoint(x: 3, y: 0)
        let points = [p0, p1, p2, p3, p4, p5, p6]
        let path = CGPath.along(points: points, closed: true)
        XCTAssertEqual(path.points, points)
    }

    func testTransform() {
        var path = CGPath.along(points: [
            CGPoint(x: 2, y: 2),
            CGPoint(x: 4, y: 4),
            CGPoint(x: 4, y: 2)
        ], closed: true)

        path = path.scaled(by: 0.5)
        XCTAssertEqual(path, CGPath.along(points: [
            CGPoint(x: 1, y: 1),
            CGPoint(x: 2, y: 2),
            CGPoint(x: 2, y: 1)
        ], closed: true))

        path = path.translated(by: CGPoint(x: -1, y: -1))
        XCTAssertEqual(path, CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 1, y: 1),
            CGPoint(x: 1, y: 0)
        ], closed: true))
    }

    func testLineSegments() {
        let path = CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0, y: 5),
            CGPoint(x: 5, y: 5)
        ], closed: true)

        let expectedSegments = [
            LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 0, y: 5)),
            LineSegment(a: CGPoint(x: 0, y: 5), b: CGPoint(x: 5, y: 5)),
            LineSegment(a: CGPoint(x: 5, y: 5), b: CGPoint(x: 0, y: 0))
        ]

        XCTAssertEqual(path.lineSegments, expectedSegments)
    }
}
