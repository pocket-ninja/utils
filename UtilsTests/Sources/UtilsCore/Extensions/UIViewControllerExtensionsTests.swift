//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

private class DelegateMock:
    NSObject,
    UIViewControllerTransitioningDelegate,
    UINavigationControllerDelegate {}

private class AnimatorMock: ViewControllerLayoutAnimator {
    var callCount: UInt = 0
    func animate(in context: Context, then completion: @escaping Completion) {
        callCount += 1
        completion()
    }
}

class UIViewControllerTests: XCTestCase {
    func testAddDropChild() {
        let parent = UIViewController()
        let child = UIViewController()
        parent.view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)

        parent.add(fullscreenChild: child)
        parent.view.layoutIfNeeded()
        XCTAssertEqual(child.view.bounds, parent.view.bounds)
        XCTAssertTrue(parent.children.contains(child))

        child.dropFromParent()
        XCTAssertFalse(parent.children.contains(child))

        /* test remove from parent twice */
        child.dropFromParent()
    }

    func testAddDropChildUsingAnimator() {
        let parent = UIViewController()
        let child = UIViewController()
        let animator = AnimatorMock()

        parent.add(child: child, using: animator)
        XCTAssertTrue(parent.children.contains(child))
        XCTAssertEqual(animator.callCount, 1)

        child.dropFromParent(using: animator) {
            /* test remove from parent twice */
            child.dropFromParent(using: animator) {
                XCTAssertNil(child.parent)
                XCTAssertEqual(animator.callCount, 2)
            }
        }
    }

    func testWithTransitioningDelegate() {
        let controller = UIViewController()
        XCTAssertNil(controller.transitioningDelegate)
        controller.with(transitioningDelegate: DelegateMock()) { XCTAssertNotNil(controller.transitioningDelegate) }
        XCTAssertNil(controller.transitioningDelegate)
    }

    func testWithNavigationDelegate() {
        let controller = UINavigationController()
        XCTAssertNil(controller.delegate)
        controller.with(delegate: DelegateMock()) { XCTAssertNotNil(controller.delegate) }
        XCTAssertNil(controller.delegate)
    }
}
