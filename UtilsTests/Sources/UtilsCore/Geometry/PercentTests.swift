//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class PercentTests: XCTestCase {
    func testIntLiteral() {
        let zero: Percent = 0
        XCTAssertEqual(zero, Percent.zero)

        let one: Percent = 2
        XCTAssertEqual(one, Percent(1))
    }

    func testFloatLiteral() {
        let fifty: Percent = 0.5
        XCTAssertEqual(fifty, Percent(0.5))

        let zero: Percent = -2.5
        XCTAssertEqual(zero, Percent(0))
    }

    func testInverted() {
        XCTAssertEqual(Percent(0.3).inverted, Percent(0.7))
    }
}
