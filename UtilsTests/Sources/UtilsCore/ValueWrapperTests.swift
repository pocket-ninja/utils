//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UtilsCore

class ValueWrapperTests: XCTestCase {
    func testValueWrapper() {
        let value = "hi"
        XCTAssertEqual(value, ValueWrapper(value).value)
    }
}
