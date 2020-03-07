//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class TargetTests: XCTestCase {
    func testTargetInitialization() {
        let target = Target(bundle: .test)
        XCTAssert(!target.displayName.isEmpty)
        XCTAssert(!target.name.isEmpty)
        XCTAssert(!target.version.isEmpty)
    }
}
