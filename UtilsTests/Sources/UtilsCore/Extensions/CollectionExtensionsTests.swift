//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class CollectionExtensionsTests: XCTestCase {
    func testSafeIndex() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertNil(array[safe: 10])
        XCTAssertEqual(array[safe: 0], 1)
    }
}

class ArrayExtensionsTests: XCTestCase {
    func testTransform() {
        var a = [1, 2, 3]
        a.transform { $0 *= 2 }
        XCTAssertEqual(a, [2, 4, 6])
    }
}
