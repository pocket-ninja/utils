//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class GenericSizeTests: XCTestCase {
    func testConversionToCGSize() {
        let cgSize = CGSize(width: 10, height: 20)
        XCTAssertEqual(Size<Int>(width: 10, height: 20).cgSize, cgSize)
        XCTAssertEqual(Size<Double>(width: 10, height: 20).cgSize, cgSize)
        XCTAssertEqual(Size<CGFloat>(width: 10, height: 20).cgSize, cgSize)
        XCTAssertEqual(Size<Float>(width: 10, height: 20).cgSize, cgSize)
    }

    func testWrongFormat() {
        XCTAssertEqual(Size<Int>(width: -1, height: 2).cgSize, CGSize(width: 0, height: 2))
        XCTAssertEqual(Size<Int>(width: -1, height: -2), .zero)
    }

    func testHashing() {
        XCTAssertNotEqual(Size<Int>(width: 1, height: 2).hashValue, Size<Int>(width: 2, height: 1).hashValue)
        XCTAssertNotEqual(Size<Int>(width: 1, height: 2), Size<Int>(width: 1, height: 1))
        XCTAssertEqual(Size<Int>(width: 1, height: 2), Size<Int>(width: 1, height: 2))
    }

    func testScaledBy() {
        XCTAssertEqual(Size<Int>(width: 2, height: 3) * 2, Size<Int>(width: 4, height: 6))
        XCTAssertEqual(Size<CGFloat>(width: 20, height: 40) * 0.25, Size<CGFloat>(width: 5, height: 10))
        XCTAssertEqual(Size<Float>(width: 20, height: 40) * 0.25, Size<Float>(width: 5, height: 10))
        XCTAssertEqual(Size<Double>(width: 20, height: 40) * 0.0, .zero)
    }
}
