import XCTest
import Utils

final class TemplateTests: XCTestCase {
    func testEnvironment() {
        XCTAssertTrue(Environment.isTests)
    }
}
