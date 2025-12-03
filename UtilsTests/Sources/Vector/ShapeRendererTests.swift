//
//  Copyright © 2025 sroik. All rights reserved.
//

import Testing
import UIKit
import SnapshotTesting
import Vector

@MainActor
@Suite(.snapshots(record: .missing, diffTool: .ksdiff))
struct ShapeRendererTests {

    var imageView: UIImageView!

    init() {
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
    }

    func testColorFill() throws {
        let cgImage = try ShapeRenderer().render(Shape.stub()).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(of: imageView, as: .image)
    }
    
    func testLargeSizeColorFill() throws {
        let cgImage = try ShapeRenderer().render(.stub(), fitting: CGSize(width: 900, height: 900)).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(of: imageView, as: .image)
    }

    func testLinearGradient() throws {
        let shape = Shape.stub(style: .stub(fill: .linearGradientStub))
        let cgImage = try ShapeRenderer().render(shape).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(of: imageView, as: .image)
    }

    func testRadialGradient() throws {
        let shape = Shape.stub(style: .stub(fill: .radialGradientStub))
        let cgImage = try ShapeRenderer().render(shape).get()
        imageView.image = UIImage(cgImage: cgImage)
        assertSnapshot(of: imageView, as: .image)
    }
}
