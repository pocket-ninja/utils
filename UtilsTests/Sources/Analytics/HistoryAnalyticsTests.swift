//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import XCTest
import Analytics

class HistoryAnalyticsTests: XCTestCase {
    func testAnalyticsCollectTrackedEvents() {
        let analytics = HistoryAnalytics()
        analytics.track(.shot)
        XCTAssertEqual(analytics.events.first, .shot)
    }

    func testAnalyticsDrainCastsToHistory() {
        let drain: AnalyticsDrain = HistoryAnalytics()
        XCTAssertNotNil(drain.history)
    }
}
