//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

struct TestSettings: Codable, Hashable {
    var value: Int = 0
}

final class SettingsServiceTests: XCTestCase {

    var service: SettingsService<TestSettings>!
    var token: CompositeToken!

    override func setUp() {
        super.setUp()
        token = CompositeToken()
        service = SettingsService<TestSettings>(
            storage: InMemoryStorage(),
            domain: "test_domain",
            defaultSettings: TestSettings(value: 123)
        )
    }

    override func tearDown() {
        service = nil
        token.cancel()
        super.tearDown()
    }

    func testBinding() {
        var value = 0
        _ = service.bind { value = $0.value }
        XCTAssertEqual(value, 123)
    }

    func testBackup() {
        let exp = expectation(description: "backup")
        token += service.subscribe {
            XCTAssertEqual($0.value, 321)
            exp.fulfill()
        }

        service.backup(TestSettings(value: 321))
        waitForExpectations(timeout: 0.1)
    }

    func testTweak() {
        let exp = expectation(description: "tweak")
        token += service.subscribe {
            XCTAssertEqual($0.value, 1)
            exp.fulfill()
        }

        service.tweak { $0.value = 1 }
        waitForExpectations(timeout: 0.1)
    }
}
