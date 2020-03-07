//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class OptionalExtensionsTests: XCTestCase {
    func testApplyToNone() {
        let value: Int? = nil
        value.apply { _ in
            XCTAssert(false)
        }
    }

    func testApplyToSome() {
        let value: Int? = 1
        let expectation = XCTestExpectation()
        value.apply { _ in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
