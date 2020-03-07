//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class TokenTests: XCTestCase {
    func testCancellation() {
        let token = SimpleToken(action: expectedAction())

        token.cancel()
        XCTAssert(token.isCancelled)

        waitForExpectations(timeout: 0.0)
    }

    func testDoubleCancel() {
        let token = SimpleToken(action: expectedAction())

        token.cancel()
        token.cancel()
        XCTAssert(token.isCancelled)

        waitForExpectations(timeout: 0.0)
    }
}

class DeinitTokenTests: XCTestCase {
    func testDeinitCancel() {
        _ = DeinitToken(action: expectedAction())

        waitForExpectations(timeout: 0.0)
    }

    func testCancelsValueToken() {
        _ = DeinitToken(token: SimpleToken(action: expectedAction()))

        waitForExpectations(timeout: 0.0)
    }
}

class TaggedTokenTests: XCTestCase {
    func testTag() {
        let tag = "tag"
        let token = TaggedToken(tag: tag as AnyObject, action: {})
        XCTAssertTrue(tag == token.tag as? String)
    }
}

class CompositeTokenTests: XCTestCase {
    func testCancelsAddedTokens() {
        let compositeToken = CompositeToken()

        compositeToken += SimpleToken(action: expectedAction())
        compositeToken.cancel()

        waitForExpectations(timeout: 0.0)
    }

    func testIgnoreAddedTokenIfAlreadyCancelled() {
        let compositeToken = CompositeToken()
        compositeToken.cancel()
        compositeToken.addOrIgnore {
            XCTAssert(false)
            return SimpleToken {}
        }
    }

    func testAddOrIgnoreIfNotCancelled() {
        let compositeToken = CompositeToken()
        compositeToken.addOrIgnore { SimpleToken(action: expectedAction()) }
        compositeToken.cancel()
        waitForExpectations(timeout: 0.0)
    }

    func testCancelsAddedTokenIfAlreadyCancelled() {
        let compositeToken = CompositeToken()
        compositeToken.cancel()

        compositeToken += SimpleToken(action: expectedAction())

        waitForExpectations(timeout: 0.0)
    }
}
