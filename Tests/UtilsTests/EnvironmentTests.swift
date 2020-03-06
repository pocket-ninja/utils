import XCTest
@testable import UtilsCore

final class TemplateTests: XCTestCase {
    func testEnvironment() {
        XCTAssertTrue(Environment.isTests)
    }
}
