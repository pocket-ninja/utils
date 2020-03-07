//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import XCTest
import Analytics

class AnalyticsTests: XCTestCase {
    func testAnalyticsTracksAppEventsInEnabledState() {
        let history = HistoryAnalytics()
        let analytics = Analytics(drains: [history])
        
        analytics.isEnabled = true
        analytics.track(.shot)
        
        XCTAssertFalse(history.events.isEmpty)
    }
    
    func testAnalyticsSkipsAppEventsInDisabledState() {
        let history = HistoryAnalytics()
        let analytics = Analytics(drains: [history])
        
        analytics.isEnabled = false
        analytics.track(.shot)
        
        XCTAssertTrue(history.events.isEmpty)
    }
    
    func testAnalyticsTracksUniqueAppEventOnce() {
        let history = HistoryAnalytics()
        let analytics = Analytics(storage: StorageMock(), drains: [history])
        analytics.isEnabled = true
        
        analytics.track(.unique)
        analytics.track(.unique)
        
        XCTAssertEqual(history.events.count, 1)
    }
    
    func testAnalyticsDrainCastsToAnalytics() {
        let drain: AnalyticsDrain = Analytics(drains: [HistoryAnalytics()])
        XCTAssertNotNil(drain.app)
    }
}
