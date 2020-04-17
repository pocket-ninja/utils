//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

@testable import UtilsCore
import XCTest

class TimeTests: XCTestCase {
    func testTimeClampsBoundingValues() {
        let time = Time(hour: 24, minute: 60)

        XCTAssertEqual(time.hour, 23)
        XCTAssertEqual(time.minute, 59)
    }
}
