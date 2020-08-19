//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UIKit
import SnapshotTesting
import Vector
import Macaw
import MacawAdditions

class ShapesLayerTests: XCTestCase {

    var container: UIView!

    override func setUp() {
        super.setUp()
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        container.backgroundColor = .white
    }

    override func tearDown() {
        container = nil
        super.tearDown()
    }

    func testShapesLayer() throws {
        #warning ("Restore with Swift 5.3 migration")
//        let url = try Bundle.test.url(forResource: "Resources/coco.svg", withExtension: nil).get()
//        let svg = try Macaw.SVGParser.parse(fullPath: url.path)
//        let shapesLayer = ShapesLayer(
//            shapes: svg.recursiveChildShapes,
//            size: try svg.viewBox.get().size
//        )
//
//        container.layer.addSublayer(shapesLayer)
//        shapesLayer.frame = container.bounds
//        shapesLayer.layoutIfNeeded()
//        assertSnapshot(matching: container, as: .image)
    }
}
