//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UtilsCore

class LineTests: XCTestCase {
    
    func testInitWithVerticalPoints() {
        let line = Line(a: CGPoint(x: 5, y: 5), b: CGPoint(x: 5, y: 10))
        XCTAssertEqual(line, Line.vertical(x: 5))
    }
    
    func testVerticalLineIsNotHorizontal() {
        XCTAssertFalse(Line.vertical(x: 1).isHorizontal)
    }
    
    func testHorizontalLineIsHorizontal() {
        XCTAssertTrue(Line.sloped(slope: 0, intercept: 1).isHorizontal)
    }
    
    func testSlopedLineIsNotHorizontal() {
        XCTAssertFalse(Line.sloped(slope: 1, intercept: 1).isHorizontal)
    }
    
    func testVerticalLineSubscript() {
        let line = Line.vertical(x: 5)
        XCTAssertNil(line[x: 1])
        XCTAssertNil(line[x: 5])
        XCTAssertEqual(line[y: 1], CGPoint(x: 5, y: 1))
        XCTAssertEqual(line[y: 100], CGPoint(x: 5, y: 100))
    }
    
    func testHorizontalLineSubscript() {
        let line = Line.sloped(slope: 0, intercept: 5)
        XCTAssertNil(line[y: 1])
        XCTAssertNil(line[y: 5])
        XCTAssertEqual(line[x: 1], CGPoint(x: 1, y: 5))
        XCTAssertEqual(line[x: 100], CGPoint(x: 100, y: 5))
    }
    
    func testSlopedLineSubscript() {
        let line = Line(a: CGPoint(x: 0, y: 5), b: CGPoint(x: 4, y: 8))
        XCTAssertEqual(line[x: 0], CGPoint(x: 0, y: 5))
        XCTAssertEqual(line[x: 4], CGPoint(x: 4, y: 8))
        XCTAssertEqual(line[y: 5], CGPoint(x: 0, y: 5))
        XCTAssertEqual(line[y: 8], CGPoint(x: 4, y: 8))
    }
    
    func testVerticalLineContains() {
        let line = Line.vertical(x: 5)
        XCTAssertFalse(line.contains(CGPoint(x: 4.9, y: -10)))
        XCTAssertFalse(line.contains(CGPoint(x: 5.1, y: 10)))
        XCTAssertTrue(line.contains(CGPoint(x: 5, y: -10)))
    }
    
    func testHorizontalLineContains() {
        let line = Line.sloped(slope: 0, intercept: 5)
        XCTAssertFalse(line.contains(CGPoint(x: -10, y: 4.9)))
        XCTAssertFalse(line.contains(CGPoint(x: 10, y: 5.1)))
        XCTAssertTrue(line.contains(CGPoint(x: -10, y: 5)))
    }
    
    func testSlopedLineContains() {
        let line = Line(a: CGPoint(x: 0, y: 5), b: CGPoint(x: 4, y: 8))
        XCTAssertFalse(line.contains(CGPoint(x: 0, y: 0)))
        XCTAssertFalse(line.contains(CGPoint(x: 4, y: 8.1)))
        XCTAssertTrue(line.contains(CGPoint(x: 0, y: 5)))
        XCTAssertTrue(line.contains(CGPoint(x: 4, y: 8)))
        XCTAssertTrue(line.contains(CGPoint(x: -4, y: 2)))
    }
    
    func testVerticalIsParallelToVertical() {
        let l2 = Line.vertical(x: 1)
        let l1 = Line.vertical(x: 2)
        XCTAssertTrue(l1.isParallel(to: l2))
        XCTAssertTrue(l2.isParallel(to: l1))
    }
    
    func testVerticalIsNotParallelToSloped() {
        let sloped = Line.sloped(slope: 0.5, intercept: 1)
        let vertical = Line.vertical(x: 1)
        XCTAssertFalse(sloped.isParallel(to: vertical))
        XCTAssertFalse(vertical.isParallel(to: sloped))
    }

    func testSlopedIsNotParallelToSloped() {
        let l1 = Line.sloped(slope: 0.5, intercept: 1)
        let l2 = Line.sloped(slope: 1, intercept: 2)
        XCTAssertFalse(l1.isParallel(to: l2))
        XCTAssertFalse(l2.isParallel(to: l1))
    }
    
    func testSlopedIsParallelToSloped() {
        let l1 = Line.sloped(slope: 0.5, intercept: 1)
        let l2 = Line.sloped(slope: 0.5, intercept: 2)
        XCTAssertTrue(l1.isParallel(to: l2))
        XCTAssertTrue(l2.isParallel(to: l1))
    }
    
    func testSlopedIntersectionWithVertical() {
        let sloped = Line.sloped(slope: 1, intercept: 1)
        let vertical = Line.vertical(x: 2)
        let intersection = CGPoint(x: 2, y: 3)
        XCTAssertEqual(sloped.intersection(with: vertical), intersection)
        XCTAssertEqual(vertical.intersection(with: sloped), intersection)
    }
    
    func testSlopedIntersectionWithSlopedWhenParallel() {
        let l1 = Line.sloped(slope: 0.5, intercept: 1)
        let l2 = Line.sloped(slope: 0.5, intercept: 2)
        XCTAssertNil(l1.intersection(with: l2))
        XCTAssertNil(l2.intersection(with: l1))
    }
    
    func testSlopedIntersectionWithSloped() {
        let l2 = Line.sloped(slope: 0, intercept: 1)
        let l1 = Line.sloped(slope: 1, intercept: 0)
        let intersection = CGPoint(x: 1, y: 1)
        XCTAssertEqual(l1.intersection(with: l2), intersection)
        XCTAssertEqual(l2.intersection(with: l1), intersection)
    }
    
    func testVerticalIntersectionWithVertical() {
        XCTAssertNil(Line.vertical(x: 0).intersection(with: .vertical(x: 1)))
        XCTAssertNil(Line.vertical(x: 1).intersection(with: .vertical(x: 1)))
    }
}
