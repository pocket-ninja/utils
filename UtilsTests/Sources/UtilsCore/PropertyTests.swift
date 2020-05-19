//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import RxPocket
import RxSwift
import RxRelay
import XCTest

class PropertyTests: XCTestCase {
    func testPropertyInitializesWithValue() {
        let property = Property(value: 0)
        XCTAssertEqual(property.value, 0)
    }
    
    func testPropertyRespectsRelayUpdate() {
        let relay = BehaviorRelay(value: 0)
        let property = Property(relay: relay)
        relay.accept(1)
        XCTAssertEqual(property.value, 1)
    }
    
    func testPropertyRespectsObservableUpdate() {
        let relay = BehaviorRelay(value: 0)
        let property = Property(value: relay.value, then: relay.asObservable())
        relay.accept(1)
        XCTAssertEqual(property.value, 1)
    }
    
    func testPropertyMapsValues() {
        let property = Property(value: 1)
        let doubledProperty = property.map { $0 * 2 }
        XCTAssertEqual(doubledProperty.value, 2)
    }
}
