//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import XCTest
import Analytics
import Analytics

class CompositeAnalyticsTests: XCTestCase {
    func testAnalyticsBroadcastEventsToDrains() {
        let firstDrain = HistoryAnalytics()
        let secondDrain = HistoryAnalytics()
        let analytics = CompositeAnalytics(drains: [firstDrain, secondDrain])
        
        analytics.track(.shot)

        XCTAssertFalse(firstDrain.events.isEmpty)
        XCTAssertFalse(secondDrain.events.isEmpty)
    }
}
