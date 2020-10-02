//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class CGPointExtensionsTests: XCTestCase {
    func testRounded() {
        XCTAssertEqual(CGPoint(x: 5.6, y: 10.4).rounded(), CGPoint(x: 6, y: 10))
    }

    func testTranslationTo() {
        let p1 = CGPoint(x: 5, y: 10)
        let p2 = CGPoint(x: 2, y: 3)
        XCTAssertEqual(p1.translation(to: p2), CGPoint(x: -3, y: -7))
    }

    func testTranslatedBy() {
        let p1 = CGPoint(x: 5, y: 10)
        let p2 = CGPoint(x: 2, y: 3)
        XCTAssertEqual(p1.translated(by: p2), CGPoint(x: 7, y: 13))
    }

    func testPrimitiveOperators() {
        XCTAssertEqual(CGPoint(x: 2, y: 3) * CGFloat(3.0), CGPoint(x: 6, y: 9))
        XCTAssertEqual(CGPoint(x: 4, y: 6) / CGFloat(-2.0), CGPoint(x: -2, y: -3))
        XCTAssertEqual(CGPoint(x: 2, y: 3) + CGPoint(x: 5, y: -1), CGPoint(x: 7, y: 2))
        XCTAssertEqual(CGPoint(x: 2, y: 3) - CGPoint(x: 5, y: -1), CGPoint(x: -3, y: 4))
        XCTAssertEqual(-CGPoint(x: 2, y: -3), CGPoint(x: -2, y: 3))
    }

    func testAbs() {
        XCTAssertEqual(CGPoint(x: -2, y: 3).abs, CGPoint(x: 2, y: 3))
    }

    func testDistanceToPoint() {
        XCTAssertEqual(CGPoint(x: 1, y: 2).distance(to: CGPoint(x: 4, y: -2)), 5)
    }

    func testAbsoluteValue() {
        let rect = CGRect(x: 20, y: 20, width: 50, height: 50)
        XCTAssertEqual(CGPoint(x: 0, y: 0).absolute(in: rect), CGPoint(x: 20, y: 20))
        XCTAssertEqual(CGPoint(x: 0.5, y: 1.0).absolute(in: rect), CGPoint(x: 45, y: 70))
    }

    func testRelatedValue() {
        let rect = CGRect(x: 20, y: 20, width: 50, height: 50)
        XCTAssertEqual(CGPoint(x: 20, y: 20).related(in: rect), CGPoint(x: 0, y: 0))
        XCTAssertEqual(CGPoint(x: 45, y: 70).related(in: rect), CGPoint(x: 0.5, y: 1.0))
    }
}

class CGSizeExtensionsTests: XCTestCase {
    func testIsEmpty() {
        XCTAssertTrue(CGSize.zero.isEmpty)
        XCTAssertTrue(CGSize(width: 0, height: 1).isEmpty)
        XCTAssertTrue(CGSize(width: 1, height: 0).isEmpty)
        XCTAssertFalse(CGSize(width: 1, height: 1).isEmpty)
    }

    func testCenter() {
        XCTAssertEqual(CGSize(width: 20, height: 12).center, CGPoint(x: 10, y: 6))
    }

    func testRatio() {
        XCTAssertNil(CGSize(width: 0, height: 1).ratio)
        XCTAssertEqual(CGSize(width: 20, height: 5).ratio, 4)
    }

    func testRounded() {
        XCTAssertEqual(CGSize(width: 3.4, height: 2.6).rounded(), CGSize(width: 3, height: 3))
    }

    func testDiffWith() {
        let s1 = CGSize(width: 5, height: 1)
        let s2 = CGSize(width: 2, height: 3)
        XCTAssertEqual(s1 - s2, CGSize(width: 3, height: -2))
    }

    func testScaledBy() {
        XCTAssertEqual(CGSize(width: 1, height: 2) * 0.5, CGSize(width: 0.5, height: 1))
    }

    func testScaleToFill() {
        let s1 = CGSize(width: 2, height: 5)
        let s2 = CGSize(width: 3, height: 10)
        let s3 = CGSize(width: 1, height: 0)
        
        XCTAssertEqual(s1.scale(toFill: s2), 2)
        XCTAssertEqual(s2.scale(toFill: s1), 2 / 3)
        XCTAssertEqual(CGSize.zero.scale(toFill: s1), 1.0)
        XCTAssertEqual(s1.scale(toFill: .zero), 0)
        XCTAssertEqual(s1.scale(toFill: s3), 0.5)
    }

    func testScaleToFit() {
        let s1 = CGSize(width: 2, height: 5)
        let s2 = CGSize(width: 3, height: 10)
        let s3 = CGSize(width: 1, height: 0)
        
        XCTAssertEqual(s1.scale(toFit: s2), 3 / 2)
        XCTAssertEqual(s2.scale(toFit: s1), 5 / 10)
        XCTAssertEqual(CGSize.zero.scale(toFit: s1), 1)
        XCTAssertEqual(s1.scale(toFit: .zero), 0)
        XCTAssertEqual(s3.scale(toFit: s1), 2)
    }

    func testRotatedSize() {
        let s1 = CGSize(width: 5, height: 5)
        let angle = CGFloat.pi / 4
        XCTAssertEqual(s1.rotated(to: angle, scaleMode: .fill), s1 * (2 ** 0.5))
        XCTAssertEqual(s1.rotated(to: angle, scaleMode: .fit), s1 / (2 ** 0.5))
    }

    func testSizeHash() {
        XCTAssertNotEqual(CGSize(width: 1, height: 2), CGSize(width: 2, height: 1))
        XCTAssertNotEqual(CGSize(width: 1, height: 2).hashValue, CGSize(width: 2, height: 1).hashValue)
    }
}

class CGRectExtensionsTests: XCTestCase {
    func testInitWithSize() {
        XCTAssertEqual(CGRect(size: CGSize(width: 2, height: 5)), CGRect(x: 0, y: 0, width: 2, height: 5))
    }

    func testTranslatedBy() {
        let rect = CGRect(x: 1, y: 2, width: 5, height: 5)
        XCTAssertEqual(rect.offsetted(by: CGPoint(x: 5, y: 7)), CGRect(x: 6, y: 9, width: 5, height: 5))
    }

    func testOperators() {
        let rect = CGRect(x: 1, y: 2, width: 3, height: 4)
        XCTAssertEqual(rect * 2.0, CGRect(x: 2, y: 4, width: 6, height: 8))
        XCTAssertEqual(rect * 0.0, CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func testCenter() {
        XCTAssertEqual(CGRect(x: 10, y: 20, width: 30, height: 40).center, CGPoint(x: 25, y: 40))
    }
    
    func testRectInitWithCenter() {
        XCTAssertEqual(
            CGRect(center: CGPoint(x: 10, y: 10), size: CGSize(width: 10, height: 10)),
            CGRect(x: 5, y: 5, width: 10, height: 10)
        )
    }
    
    func testCenteredIn() {
        let innerRect = CGRect(x: 0, y: 0, width: 50, height: 100)
        let outerRect = CGRect(x: 10, y: 15, width: 200, height: 300)
        let centeredRect = innerRect.centered(in: outerRect)
        XCTAssertEqual(centeredRect, CGRect(x: 85, y: 115, width: 50, height: 100))
    }

    func testFittedIn() {
        let innerRect = CGRect(x: 0, y: 0, width: 50, height: 100)
        let outerRect = CGRect(x: 10, y: 15, width: 200, height: 300)
        let rect = innerRect.fitted(in: outerRect)
        XCTAssertEqual(rect, CGRect(x: 35, y: 15, width: 150, height: 300))
    }

    func testFilledIn() {
        let innerRect = CGRect(x: 0, y: 0, width: 50, height: 100)
        let outerRect = CGRect(x: 10, y: 15, width: 200, height: 300)
        let rect = innerRect.filled(in: outerRect)
        XCTAssertEqual(rect, CGRect(x: 10, y: -35, width: 200, height: 400))
    }

    func testTransformToBecome() {
        XCTAssertEqual(CGRect.zero.transform(toBecome: .zero), CGAffineTransform.identity)

        let rect = CGRect(x: 0, y: 0, width: 10, height: 20)
        let destination = CGRect(x: 1, y: -2, width: 5, height: 100)
        let transform = rect.transform(toBecome: destination)

        /* don't test using CGRect.applying(transform)*/
        let layer = CALayer()
        layer.frame = rect
        layer.setAffineTransform(transform)
        XCTAssertEqual(layer.frame, destination)
    }
}

class UIEdgeInsetsExtensionsTests: XCTestCase {
    func testProperties() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        XCTAssertEqual(insets.horizontal, 2 + 4)
        XCTAssertEqual(insets.vertical, 1 + 3)
    }

    func testInsetting() {
        let insets = UIEdgeInsets(top: -1, left: 1, bottom: 2, right: 3)
        let size = CGSize(width: 5, height: 10)
        let rect = CGRect(origin: .zero, size: size)
        XCTAssertEqual(insets.inset(size), CGSize(width: 5 - 1 - 3, height: 10 + 1 - 2))
        XCTAssertEqual(insets.inset(rect), CGRect(x: 1, y: -1, width: 5 - 1 - 3, height: 10 + 1 - 2))
    }
}
