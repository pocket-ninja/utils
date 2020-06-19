//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation
import XCTest
import UtilsCore

class ClampingWrapperTests: XCTestCase {
    func testClampsHigherValues() throws {
        var wrapper = Clamping(wrappedValue: 0, 0...5)
        wrapper.wrappedValue = 10
        XCTAssertEqual(wrapper.wrappedValue, 5)
    }
    
    func testClampsLowerValues() {
        var wrapper = Clamping(wrappedValue: 0, 0...5)
        wrapper.wrappedValue = -10
        XCTAssertEqual(wrapper.wrappedValue, 0)
    }
    
    func testAllowsInRangeValues() {
        let wrapper = Clamping(wrappedValue: 3, 0...5)
        XCTAssertEqual(wrapper.wrappedValue, 3)
    }
}
