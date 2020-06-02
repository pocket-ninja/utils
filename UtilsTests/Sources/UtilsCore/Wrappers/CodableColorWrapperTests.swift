//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation
import XCTest
import UtilsCore

class CodableColorWrapperTests: XCTestCase {
    func testCodableEncodesAndDecodesColor() throws {
        let original = CodableColor(wrappedValue: .black)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(CodableColor.self, from: data)

        XCTAssertEqual(original, decoded)
    }
}
