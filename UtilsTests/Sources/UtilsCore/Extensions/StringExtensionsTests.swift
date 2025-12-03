//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UniformTypeIdentifiers
@testable import UtilsCore

class StringTests: XCTestCase {
    func testEmptyString() {
        XCTAssertEqual(String.empty, "")
    }

    func testSubscriptiptClosedRange() {
        XCTAssertEqual("".substring(from: 0, to: 0), "")
        XCTAssertEqual("".substring(from: 0, to: 1), "")
        XCTAssertEqual("123".substring(from: 2, to: -1), "")
        XCTAssertEqual("123".substring(from: 0, to: 5), "123")
        XCTAssertEqual("123".substring(from: -1, to: 5), "123")
        XCTAssertEqual("123".substring(from: 0, to: 2), "123")
        XCTAssertEqual("123".substring(from: 1, to: 2), "23")
    }
    
    func testAppendings() {
        XCTAssertEqual("some/path".appending(pathComponent: "added"), "some/path/added")
        XCTAssertEqual("some/path".appending(pathExtension: "ext"), "some/path.ext")
        XCTAssertEqual("some/path".appending(pathExtensionFor: .png), "some/path.png")
        XCTAssertEqual("some/path.png".replacingPathExtension(to: .jpeg), "some/path.jpeg")
        XCTAssertEqual("some/path".replacingPathExtension(to: .jpeg), "some/path.jpeg")
    }
}
