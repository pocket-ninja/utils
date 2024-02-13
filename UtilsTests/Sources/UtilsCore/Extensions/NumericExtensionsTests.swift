//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class MathTests: XCTestCase {
    func testTimes() {
        var callCount = 0
        10.times { callCount += 1 }
        XCTAssertEqual(callCount, 10)
    }

    func testClamping() {
        XCTAssertEqual(10.clamped(from: 0, to: 5), 5)
        XCTAssertEqual((-10).clamped(from: 0, to: 5), 0)
        XCTAssertEqual(3.clamped(from: 0, to: 5), 3)
    }
    
    func testLerp() {
        XCTAssertEqual(lerp(from: -2, to: 2, time: 0.5), 0)
        XCTAssertEqual(lerp(from: -2, to: 2, time: 2), 6)
        
        XCTAssertEqual(lerp(from: 10, to: 0, time: 0.2), 8)
        XCTAssertEqual(lerp(from: 10, to: 0, time: 1), 0)
    }
    
    func testInverseLerp() {
        XCTAssertEqual(inverseLerp(from: -2, to: 2, value: 0), 0.5)
        XCTAssertEqual(inverseLerp(from: -2, to: 2, value: 6), 2)
        
        XCTAssertEqual(inverseLerp(from: 10, to: 0, value: 8), 0.2)
        XCTAssertEqual(inverseLerp(from: 10, to: 0, value: 0), 1)
    }
}
