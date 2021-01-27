//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import CoreGraphics
@testable import UtilsCore

class CGAffineTransformExtensionsTests: XCTestCase {

    func testScale() {
        var t = CGAffineTransform(scaleX: -1.5, y: 2.0)
        XCTAssertEqual(t.signScale, CGPoint(x: -1.5, y: 2.0))
        XCTAssertEqual(t.absScale, CGPoint(x: 1.5, y: 2.0))
        
        t = t.scaledBy(x: 2, y: 3)
        XCTAssertEqual(t.signScale, CGPoint(x: -3, y: 6.0))
    }

    func testRotation() {
        let t = CGAffineTransform(rotationAngle: 2.0)
        XCTAssertEqual(t.rotation, 2.0)
    }

    func testTrasnlation() {
        let t = CGAffineTransform(translationX: 10, y: 20).translated(to: CGPoint(x: 5, y: 6))
        XCTAssertEqual(t.tx, 5)
        XCTAssertEqual(t.ty, 6)
    }
}
