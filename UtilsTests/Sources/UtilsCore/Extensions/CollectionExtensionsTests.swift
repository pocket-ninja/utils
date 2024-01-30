//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class CollectionExtensionsTests: XCTestCase {
    private struct TestModel<T>: Identifiable {
        var id: String
        var value: T
    }
    
    func testSafeIndex() {
        let array = [1, 2, 3, 4, 5]
        XCTAssertNil(array[safe: 10])
        XCTAssertEqual(array[safe: 0], 1)
    }
    
    func testUpdateOrAppend() {
        var array: [TestModel<Int>] = [.init(id: "1", value: 1)]

        array.updateOrAppend(.init(id: "1", value: 2))
        XCTAssertEqual(array[0].value, 2)
        XCTAssertEqual(array.count, 1)
        
        array.updateOrAppend(.init(id: "2", value: 2))
        XCTAssertEqual(array.count, 2)
        XCTAssertEqual(array[1].value, 2)
    }
}

class ArrayExtensionsTests: XCTestCase {
    func testTransform() {
        var a = [1, 2, 3]
        a.transform { $0 *= 2 }
        XCTAssertEqual(a, [2, 4, 6])
    }
}
