//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class StringTests: XCTestCase {
    func testEmptyString() {
        XCTAssertEqual(String.empty, "")
    }

    func testSubscriptiptClosedRange() {
        XCTAssertEqual("".substring(from: 0, to: 0), "")
        XCTAssertEqual("".substring(from: 0, to: 1), "")
        XCTAssertEqual("123".substring(from: 2, to: -1), "")
        XCTAssertEqual("123".substring(from: 0, to: 5), "123")
        XCTAssertEqual("123".substring(from: -1, to: 5), "123")
        XCTAssertEqual("123".substring(from: 0, to: 2), "123")
        XCTAssertEqual("123".substring(from: 1, to: 2), "23")
    }
}
