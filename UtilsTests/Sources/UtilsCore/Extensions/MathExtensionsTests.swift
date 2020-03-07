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
}
