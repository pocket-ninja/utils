//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

extension CGPath {
    static var ellipseStub: CGPath {
        return CGPath(ellipseIn: CGRect(x: 0, y: 0, width: 100, height: 75), transform: nil)
    }
    
    static var cornerStub: CGPath {
        return CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 60, y: 0),
            CGPoint(x: 60, y: 30),
            CGPoint(x: 10, y: 30),
            CGPoint(x: 10, y: 100),
            CGPoint(x: 0, y: 100)
        ], closed: true)
    }

    static var polygonStub: CGPath {
        return CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 10, y: 20),
            CGPoint(x: 40, y: 20),
            CGPoint(x: 40, y: 50),
            CGPoint(x: 70, y: 50),
            CGPoint(x: 70, y: 30),
            CGPoint(x: 50, y: 10),
            CGPoint(x: 20, y: 10)
        ], closed: true)
    }

    static var arrowStub: CGPath {
        return CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 50, y: 100),
            CGPoint(x: 100, y: 0),
            CGPoint(x: 50, y: 35)
        ], closed: true)
    }

    static var triangleStub: CGPath {
        return CGPath.along(points: [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 50, y: 100),
            CGPoint(x: 100, y: 0)
        ], closed: true)
    }
}
