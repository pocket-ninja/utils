//
//  Copyright © 2020 sroik. All rights reserved.
//

import Testing
import SnapshotTesting
import UIKit
@testable import UtilsCore

@MainActor
@Suite(.snapshots(record: .missing, diffTool: .ksdiff))
struct UIColorExtensionsTests {
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    init() {
        imageView.contentMode = .center
        imageView.backgroundColor = .white
    }
    
    @Test func testImage() {
        let image = UIColor.white.image
        #expect(image.size == CGSize(width: 1, height: 1))
    }

    @Test func testIsEqual() {
        #expect(UIColor.black.isEqual(to: UIColor(white: 0, alpha: 1)))
        #expect(!UIColor.black.isEqual(to: nil))

        let c1 = UIColor(white: 0, alpha: 1)
        let c2 = UIColor(white: 0.1, alpha: 1)
        #expect(!c1.isEqual(to: c2))
        #expect(c1.isEqual(to: c2, withThreshold: 0.2))
    }

    @Test func testInitWithInvalidHex() {
        #expect(UIColor(hex: "#wrong_format") == nil)
        #expect(UIColor(hex: "#FFFFFFFFF") == nil)
        #expect(UIColor(hex: "#0000") == nil)
    }
    
    @Test func testInitWithHex6() {
        #expect(UIColor(hex: "#FFFFFF")!.isEqual(to: .white))
    }

    @Test func testInitWithHex8() {
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 26/255)
        #expect(UIColor(hex: "#0000001A")!.isEqual(to: color))
    }

    @Test func testIsLight() {
        #expect(UIColor.white.isLight)
        #expect(UIColor.lightGray.isLight)
        #expect(!UIColor.black.isLight)
        #expect(!UIColor.darkGray.isLight)
    }

    @Test func testInitWithRGBAString() {
        #expect(UIColor(string: "") == nil)
        #expect(UIColor(string: "0.5 0.5 0.5 shit") == nil)
        #expect(UIColor(string: "0 0 0")!.isEqual(to: .black))
        #expect(UIColor(string: "1 1 1 1")!.isEqual(to: .white))
        #expect(UIColor(string: "1 - 1 - 1", separator: "-")!.isEqual(to: .white))
        #expect(UIColor(string: "0.1 0.2 0.3 0.4")!.isEqual(to: UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 0.4)))
    }

    @Test func testHex6StringWithoutAlpha() {
        #expect(UIColor.black.hexString == "000000")
        #expect(UIColor.white.hexString == "FFFFFF")
    }
    
    @Test func testHex8StringWithoutAlpha() {
        #expect(UIColor.black.withAlphaComponent(26/255).hexString == "0000001A")
        #expect(UIColor.white.withAlphaComponent(26/255).hexString == "FFFFFF1A")
    }

    @Test func testRGBAString() {
        let colors: [UIColor] = [.white, .red, .blue, .yellow]
        for c in colors {
            #expect(UIColor(string: c.rgbaString)?.isEqual(to: c) == true)
        }
    }

    @Test func testHSBATuple() {
        let color = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7)
        let expected: UIColor.HSBATuple = (0, 1, 1, 0.7)
        #expect(color.hsba == expected)
    }

    @Test func testMix() {
        let c1 = UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        let c2 = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        #expect(c1.mixed(with: c2, proportion: 0) == c2)
        #expect(c1.mixed(with: c2, proportion: 1) == c1)
        #expect(c1.mixed(with: c2, proportion: 0.5) == UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))

        #expect(c1.lightened(intensity: 0.6) == UIColor(red: 1, green: 0.7, blue: 0.4, alpha: 1))
        #expect(c1.darkened(intensity: 0.5) == UIColor(red: 0.5, green: 0.25, blue: 0, alpha: 1))
    }
    
    @Test func testImageWithRoundedCorners() {
        imageView.image = UIColor.red.image(size: CGSize(width: 50, height: 50), cornerRadius: 20)
        assertSnapshot(of: imageView, as: .image)
    }
}
