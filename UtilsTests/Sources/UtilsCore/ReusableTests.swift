//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

private class Object: Reusable {}

class ReusableTests: XCTestCase {
    func testIdentifier() {
        XCTAssert(!Object.reusableIdentifier.isEmpty)
    }
}
