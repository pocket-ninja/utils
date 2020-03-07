//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

final class MockRateReviewController: RateReviewController {
    var requestsCount: Int = 0

    func requestReview() {
        requestsCount += 1
    }
}

class RateReviewServiceTests: XCTestCase {
    func testRequestReview() {
        let config = RateReviewConfig(storage: InMemoryStorage(), eventsPerRate: 7)
        let rrController = MockRateReviewController()
        let service = RateReviewService(config: config, controller: rrController)

        for i in 0...50 {
            let isRequested = service.requestReview()
            XCTAssertEqual(isRequested, i % 7 == 0)
            XCTAssertEqual(rrController.requestsCount, 1 + i / 7)
        }
    }
}
