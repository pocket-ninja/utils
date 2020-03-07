//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class QueueTests: XCTestCase {

    func testOrderedQueue() {
        var queue = Queue(items: Array(0 ... 10).shuffled(), comparator: { $0 < $1 })
        queue.append(Array(11 ... 15).shuffled())
        for i in 0 ... 15 {
            XCTAssertEqual(queue.next(), i)
        }
    }

    func testQueue() {
        var queue = Queue(items: Array(0 ... 10))
        queue.append(11)
        XCTAssertEqual(queue.peek(), 0)

        for i in 0 ... 11 {
            XCTAssertEqual(queue.next(), i)
            XCTAssertEqual(queue.isEmpty, i == 11)
        }

        XCTAssertEqual(queue.size, 0)
        XCTAssertNil(queue.peek())
        XCTAssertNil(queue.next())
    }

    func testRemoveAll() {
        var queue = Queue(items: Array(0 ... 10))
        XCTAssertFalse(queue.isEmpty)
        queue.removeAll()
        XCTAssertTrue(queue.isEmpty)
    }

    func testComparatorUpdate() {
        var queue = Queue(items: [2, 3, 1])
        XCTAssertEqual(queue.items, [2, 3, 1])
        queue.comparator = { $0 < $1 }
        XCTAssertEqual(queue.items, [1, 2, 3])
    }
}
