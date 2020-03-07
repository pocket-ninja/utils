//
// Copyright (c) 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class PersistenceCounterTests: XCTestCase {

    var counter: PersistentCounter!
    var domain: String!

    override func setUp() {
        super.setUp()

        domain = "com.unittest.persistence_counter.domain"
        counter = PersistentCounter(storage: InMemoryStorage(), domain: domain)
    }

    override func tearDown() {
        counter = nil
        super.tearDown()
    }

    func testCounter() {
        (1 ... 10).forEach {
            counter.increase()
            XCTAssertEqual(self.counter.count, UInt($0))
        }

        counter.advance(by: 10)
        XCTAssertEqual(self.counter.count, 20)
    }
}
