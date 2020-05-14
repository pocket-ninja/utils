//
//  Copyright © 2018 appcraft. All rights reserved.
//

import XCTest
import Vector

class ShapeTests: XCTestCase {
    func testColorStyleCodable() throws {
        let shape = Shape.stub()
        let encoded = try shape.encoded()
        let decoded: Shape = try encoded.decoded()
        XCTAssertEqual(shape, decoded)
    }
    
    func testRadialGradientStyleCodable() throws {
        let shape = Shape.stub(style: .stub(fill: .radialGradientStub))
        let encoded = try shape.encoded()
        let decoded: Shape = try encoded.decoded()
        XCTAssertEqual(shape, decoded)
    }
    
    func testLinearGradientStyleCodable() throws {
        let shape = Shape.stub(style: .stub(fill: .linearGradientStub))
        let encoded = try shape.encoded()
        let decoded: Shape = try encoded.decoded()
        XCTAssertEqual(shape, decoded)
    }
}
