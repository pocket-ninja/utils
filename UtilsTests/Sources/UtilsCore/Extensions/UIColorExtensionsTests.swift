//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import UtilsCore

class UIColorExtensionsTests: XCTestCase {
    
    var imageView: UIImageView!
    
    override func setUp() {
        super.setUp()
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .center
        imageView.backgroundColor = .white
    }
    
    func testImage() {
        let image = UIColor.white.image
        XCTAssertEqual(image.size, CGSize(width: 1, height: 1))
    }

    func testIsEqual() {
        XCTAssertTrue(UIColor.black.isEqual(to: UIColor(white: 0, alpha: 1)))
        XCTAssertFalse(UIColor.black.isEqual(to: nil))

        let c1 = UIColor(white: 0, alpha: 1)
        let c2 = UIColor(white: 0.1, alpha: 1)
        XCTAssertFalse(c1.isEqual(to: c2))
        XCTAssertTrue(c1.isEqual(to: c2, withThreshold: 0.2))
    }

    func testInitWithInvalidHex() {
        XCTAssertNil(UIColor(hex: "#wrong_format"))
        XCTAssertNil(UIColor(hex: "#FFFFFFFFF"))
        XCTAssertNil(UIColor(hex: "#0000"))
    }
    
    func testInitWithHex6() {
        XCTAssertTrue(UIColor(hex: "#FFFFFF")!.isEqual(to: .white))
    }

    func testInitWithHex8() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 26/255)
        XCTAssertTrue(UIColor(hex: "#0000001A")!.isEqual(to: color))
    }

    func testIsLight() {
        XCTAssertTrue(UIColor.white.isLight)
        XCTAssertTrue(UIColor.lightGray.isLight)
        XCTAssertFalse(UIColor.black.isLight)
        XCTAssertFalse(UIColor.darkGray.isLight)
    }

    func testInitWithRGBAString() {
        XCTAssertNil(UIColor(string: ""))
        XCTAssertNil(UIColor(string: "0.5 0.5 0.5 shit"))
        XCTAssertNil(UIColor(string: "0.1 0.1 2"))
        XCTAssertTrue(UIColor(string: "0 0 0")!.isEqual(to: .black))
        XCTAssertTrue(UIColor(string: "1 1 1 1")!.isEqual(to: .white))
        XCTAssertTrue(UIColor(string: "1 - 1 - 1", separator: "-")!.isEqual(to: .white))
        XCTAssertTrue(UIColor(string: "0.1 0.2 0.3 0.4")!.isEqual(to: UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.4)))
    }

    func testHex6StringWithoutAlpha() {
        XCTAssertEqual(UIColor.black.hexString, "000000")
        XCTAssertEqual(UIColor.white.hexString, "FFFFFF")
    }
    
    func testHex8StringWithoutAlpha() {
        XCTAssertEqual(UIColor.black.withAlphaComponent(26/255).hexString, "0000001A")
        XCTAssertEqual(UIColor.white.withAlphaComponent(26/255).hexString, "FFFFFF1A")
    }

    func testRGBAString() {
        let colors: [UIColor] = [.white, .red, .blue, .yellow]
        for c in colors {
            XCTAssert(UIColor(string: c.rgbaString)?.isEqual(to: c) == true)
        }
    }

    func testHSBATuple() {
        let color = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7)
        let expected: UIColor.HSBATuple = (0, 1, 1, 0.7)
        XCTAssertTrue(color.hsba == expected)
    }

    func testMix() {
        let c1 = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        let c2 = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        XCTAssertEqual(c1.mixed(with: c2, proportion: 0), c2)
        XCTAssertEqual(c1.mixed(with: c2, proportion: 1), c1)
        XCTAssertEqual(c1.mixed(with: c2, proportion: 0.5), UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))

        XCTAssertEqual(c1.lightened(intensity: 0.6), UIColor(red: 1, green: 0.7, blue: 0.4, alpha: 1))
        XCTAssertEqual(c1.darkened(intensity: 0.5), UIColor(red: 0.5, green: 0.25, blue: 0, alpha: 1))
    }
    
    func testImageWithRoundedCorners() {
        imageView.image = UIColor.red.image(size: CGSize(width: 50, height: 50), cornerRadius: 20)
        assertSnapshot(matching: imageView, as: .image)
    }
}
