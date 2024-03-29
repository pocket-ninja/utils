//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting
import Vector

class ShapeRendererTests: XCTestCase {

    var imageView: UIImageView!

    override func setUp() {
        super.setUp()
        isRecording = false
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
    }

    override func tearDown() {
        imageView = nil
        super.tearDown()
    }

    func testColorFill() throws {
        let cgImage = try ShapeRenderer().render(Shape.stub()).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(matching: imageView, as: .image)
    }
    
    func testLargeSizeColorFill() throws {
        let cgImage = try ShapeRenderer().render(.stub(), fitting: CGSize(width: 900, height: 900)).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(matching: imageView, as: .image)
    }

    func testLinearGradient() throws {
        let shape = Shape.stub(style: .stub(fill: .linearGradientStub))
        let cgImage = try ShapeRenderer().render(shape).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(matching: imageView, as: .image)
    }

    func testRadialGradient() throws {
        let shape = Shape.stub(style: .stub(fill: .radialGradientStub))
        let cgImage = try ShapeRenderer().render(shape).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(matching: imageView, as: .image)
    }
}
