//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class AppSessionCounterTests: XCTestCase {

    var counter: SessionCounter!
    var storage: Storage!
    let domain = "test"

    override func setUp() {
        super.setUp()
        storage = InMemoryStorage()
        counter = SessionCounter(version: "1", storage: storage, domain: domain)
    }

    override func tearDown() {
        counter = nil
        storage = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(counter.versionAgnosticSession, 0)
        XCTAssertEqual(counter.versionSpecificSession, 0)
    }

    func testCounterStart() {
        counter.start()
        XCTAssertEqual(counter.versionAgnosticSession, 1)
        XCTAssertEqual(counter.versionSpecificSession, 1)
    }

    func testStartTwice() {
        counter.start()
        counter.start()
        XCTAssertEqual(counter.versionAgnosticSession, 1)
        XCTAssertEqual(counter.versionSpecificSession, 1)
    }

    func testActivateNotStarted() {
        counter.activate()
        XCTAssertEqual(counter.versionAgnosticSession, 0)
        XCTAssertEqual(counter.versionSpecificSession, 0)
    }

    func testActivateMultipleTimes() {
        counter.start()
        (0..<10).forEach { _ in counter.activate() }
        XCTAssertEqual(counter.versionAgnosticSession, 11)
        XCTAssertEqual(counter.versionSpecificSession, 11)
    }

    func testVersionSpecificCount() {
        counter.start()
        (0..<10).forEach { _ in counter.activate() }

        let secCounter = SessionCounter(version: "2", storage: storage, domain: domain)
        XCTAssertEqual(secCounter.versionAgnosticSession, 11)
        XCTAssertEqual(secCounter.versionSpecificSession, 0)
    }
}
