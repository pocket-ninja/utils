//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class DataExtensionsTests: XCTestCase {
    func testInitWithOddHexString() {
        let hex = "123"
        let data = Data(hex: hex)
        XCTAssertNil(data)
    }

    func testInitWithEvenHexString() {
        let hex = "123456"
        let data = Data(hex: hex)
        XCTAssertEqual(data?.hexString, hex)

        var expected = Data()
        ["12", "34", "56"].forEach { expected.append(UInt8($0, radix: 16)!) }
        XCTAssertEqual(data, expected as Data)
    }

    func testInitWithEmptyHex() {
        let data = Data(hex: "")
        XCTAssertEqual(data, Data())
    }
}
