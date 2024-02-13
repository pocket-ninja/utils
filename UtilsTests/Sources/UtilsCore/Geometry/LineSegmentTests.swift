//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UtilsCore

class LineSegmentTests: XCTestCase {

    func testZeroLength() {
        let a = CGPoint(x: 1, y: 1)
        let b = CGPoint(x: 1, y: 1)
        let ls = LineSegment(a: a, b: b)
        XCTAssertEqual(ls.length, 0)
    }

    func testDistanceToPointWithPerpendicularIntersection() {
        let ls1 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 2, y: 0))
        XCTAssertEqual(ls1.distance(to: CGPoint(x: 1, y: 5)), 5)

        let ls2 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 4, y: 4))
        XCTAssertEqual(ls2.distance(to: CGPoint(x: 0, y: 6)), sqrt(18))
    }

    func testDistanceToPointWithoutPerpendicularIntersection() {
        let ls = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 2, y: 0))
        let p1 = CGPoint(x: -1, y: 1)
        XCTAssertEqual(ls.distance(to: p1), ls.a.distance(to: p1))

        let p2 = CGPoint(x: 3, y: 1)
        XCTAssertEqual(ls.distance(to: p2), ls.b.distance(to: p2))
    }
    
    func testParallelSegmentsIntersection() {
        let l1 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 1, y: 1))
        let l2 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 2, y: 2))
        XCTAssertNil(l1.intersection(with: l2))
    }
    
    func testConnectedSegmentsIntersection() {
        let l1 = LineSegment(a: CGPoint(x: 1, y: 1), b: CGPoint(x: 2, y: 2))
        let l2 = LineSegment(a: CGPoint(x: 1, y: 0), b: CGPoint(x: 2, y: 2))
        let intersection = CGPoint(x: 2, y: 2)
        XCTAssertEqual(l1.intersection(with: l2), intersection)
    }
    
    func testIntersectedSegmentsIntersection() {
        let l1 = LineSegment(a: CGPoint(x: 0, y: 2), b: CGPoint(x: 2, y: 0))
        let l2 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 2, y: 2))
        let intersection = CGPoint(x: 1, y: 1)
        XCTAssertEqual(l1.intersection(with: l2), intersection)
    }
    
    func testNonIntersectedSegmentsIntersection() {
        let l1 = LineSegment(a: CGPoint(x: 0, y: 0), b: CGPoint(x: 0, y: 10))
        let l2 = LineSegment(a: CGPoint(x: 5, y: 5), b: CGPoint(x: 10, y: 10))
        XCTAssertNil(l1.intersection(with: l2))
    }
}
