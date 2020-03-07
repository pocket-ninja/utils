//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class ChannelTests: XCTestCase {
    func testSyncNotifiesSubscribers() {
        let channel = Channel<Int>()

        let callback = expectation(description: "callback")
        let token = channel.subscribe { value in
            XCTAssertEqual(value, 10)
            callback.fulfill()
        }
        defer { _ = token }

        channel.send(10)
        waitForExpectations(timeout: 0.0)
    }

    func testAsyncNotifiesSubscribers() {
        let channel = Channel<Int>()
        let queue = DispatchQueue(label: "serial_queue")

        let callback = expectation(description: "callback")
        let token = channel.subscribe(on: queue) { value in
            XCTAssertEqual(value, 10)
            XCTAssertEqual(DispatchQueue.currentQueueLabel, "serial_queue")
            callback.fulfill()
        }
        defer { _ = token }

        channel.send(10)
        waitForExpectations(timeout: 0.5)
    }

    func testUnsubsribesWithToken() {
        let channel = Channel<Int>()

        let callback = expectation(description: "callback")
        callback.isInverted = true
        _ = channel.subscribe { value in
            XCTAssertEqual(value, 10)
            callback.fulfill()
        }

        channel.send(10)
        waitForExpectations(timeout: 0.0)
    }
}

private extension DispatchQueue {
    static var currentQueueLabel: String? {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))
    }
}
