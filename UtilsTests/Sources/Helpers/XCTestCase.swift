//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import XCTest

enum TestError: Error {
    case unknown
}

extension XCTestCase {
    func expectedAction(
        description: String = "expect to be called",
        inverted: Bool = false
    ) -> (() -> Void) {
        let callback = expectation(description: description)
        callback.isInverted = inverted
        return { callback.fulfill() }
    }
}
