//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class TargetTests: XCTestCase {
    func testTargetInitialization() {
        let target = Target(bundle: .test)
        XCTAssertFalse(target.displayName.isEmpty)
        XCTAssertFalse(target.name.isEmpty)
    }
}
