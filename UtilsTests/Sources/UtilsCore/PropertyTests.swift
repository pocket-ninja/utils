//
//  Copyright © 2020 sroik. All rights reserved.
//

@testable import UtilsCore
import XCTest

class PropertyTests: XCTestCase {

    var token: CompositeToken!

    override func setUp() {
        super.setUp()
        token = CompositeToken()
    }

    override func tearDown() {
        token.cancel()
        token = nil
        super.tearDown()
    }

    func testStoresValue() {
        let property = Property(value: 0)
        XCTAssertEqual(property.value, 0)

        property.value = 10
        XCTAssertEqual(property.value, 10)
    }

    func testSyncValueBinding() {
        let property = Property(value: 10)
        var value = 0
        token += property.bind { value = $0 }
        XCTAssertEqual(value, property.value)
    }

    func testSyncNotifiesSubscribers() {
        let property = Property(value: 0)

        let callback = expectation(description: "callback")
        token += property.subscribe { value in
            XCTAssertEqual(value, 10)
            callback.fulfill()
        }

        property.value = 10
        waitForExpectations(timeout: 0.0)
    }

    func testAsyncNotifiesSubscribers() {
        let property = Property(value: 0)
        let queue = DispatchQueue(label: "serial_queue")

        let callback = expectation(description: "callback")
        token += property.subscribe(on: queue) { value in
            XCTAssertEqual(value, 10)
            XCTAssertEqual(DispatchQueue.currentQueueLabel, "serial_queue")
            callback.fulfill()
        }

        property.value = 10
        waitForExpectations(timeout: 0.5)
    }

    func testUnsubsribesWithToken() {
        let property = Property(value: 0)

        let callback = expectation(description: "callback")
        callback.isInverted = true
        _ = property.subscribe { value in
            XCTAssertEqual(value, 10)
            callback.fulfill()
        }

        property.value = 10
        waitForExpectations(timeout: 0.0)
    }
}

private extension DispatchQueue {
    static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
