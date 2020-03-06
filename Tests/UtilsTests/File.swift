//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import XCTest
@testable import Analytics

class HistoryAnalyticsTests: XCTestCase {
    func testAnalyticsCollectTrackedEvents() {
        let analytics = HistoryAnalytics()
        analytics.track(Event.shot)
        XCTAssertEqual(analytics.events.first, Event.shot)
    }

    func testAnalyticsDrainCastsToHistory() {
        let drain: AnalyticsDrain = HistoryAnalytics()
        XCTAssertNotNil(drain.history)
    }
}

private extension Event {
    static let shot: Event = .plain(name: "Shot")
}
