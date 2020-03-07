//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UIKit
@testable import UtilsCore

class ActionTargetTests: XCTestCase {
    var control: UIControl!
    var token: Token!

    override func setUp() {
        super.setUp()
        control = UIControl()
    }

    override func tearDown() {
        control = nil
        token = nil
        super.tearDown()
    }

    func testPerformsCallbackOnEvent() {
        let callback = expectedAction()
        token = control.subscribe(to: .valueChanged) { callback() }

        control.sendActions(for: .valueChanged)
        waitForExpectations(timeout: 0.0)
    }

    func testUnsubscribesFromEvent() {
        let callback = expectedAction(inverted: true)

        token = control.subscribe(to: .valueChanged) { callback() }
        token.cancel()

        control.sendActions(for: .valueChanged)
        waitForExpectations(timeout: 0.0)
    }
}
