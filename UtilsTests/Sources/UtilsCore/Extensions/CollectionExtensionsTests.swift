//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class CollectionExtensionsTests: XCTestCase {
    func testUniqueGeneration() {
        let array = ["5", "4", "3", "4", "3", "2", "10"]
        let expected = ["5", "4", "3", "2", "10"]
        XCTAssert(array.unique() == expected)
    }

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

    func testChunks() {
        let a = [1, 2, 3, 4, 5, 6]
        XCTAssertEqual(a.chunks(3), [[1, 2, 3], [4, 5, 6]])
        XCTAssertTrue(a.chunks(2) { $0.count } == [2, 2, 2])
    }
}
