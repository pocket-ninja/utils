//
//  Copyright © 2020 sroik. All rights reserved.
//

#if os(iOS)
import UIKit

public struct ViewControllerLayoutContext {
    public let parent: UIViewController
    public let child: UIViewController
    public let container: UIView
    public let animated: Bool
    public let presenting: Bool
}

public protocol ViewControllerLayoutAnimator {
    typealias Completion = () -> Void
    typealias Context = ViewControllerLayoutContext
    func animate(in context: Context, then completion: @escaping Completion)
}

public extension UIViewController {
    typealias LayoutCallback = (UIViewController, UIViewController) -> Void
    typealias LayoutAnimator = ViewControllerLayoutAnimator

    var topPresentedViewController: UIViewController {
        return presentedViewController.flatMap {
            $0.topPresentedViewController
        } ?? self
    }
    
    func add(child: UIViewController, withLayout layout: LayoutCallback = { _, _ in }) {
        add(child: child, in: view, withLayout: layout)
    }

    func add(
        child: UIViewController,
        in container: UIView,
        withLayout layout: LayoutCallback = { _, _ in }
    ) {
        child.willMove(toParent: self)
        container.addSubview(child.view)
        layout(self, child)
        addChild(child)
        child.didMove(toParent: self)
    }

    func add(fullscreenChild controller: UIViewController) {
        add(fullscreenChild: controller, in: view)
    }

    func add(fullscreenChild controller: UIViewController, in container: UIView) {
        add(child: controller, in: container) { _, child in
            child.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                child.view.topAnchor.constraint(equalTo: container.topAnchor),
                child.view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                child.view.leftAnchor.constraint(equalTo: container.leftAnchor),
                child.view.rightAnchor.constraint(equalTo: container.rightAnchor)
            ])
        }
    }

    func dropFromParent() {
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
        didMove(toParent: nil)
    }

    func with(transitioningDelegate
        delegate: UIViewControllerTransitioningDelegate, _ block: () -> Void) {
        let currentDelegate = transitioningDelegate
        transitioningDelegate = delegate
        block()
        transitioningDelegate = currentDelegate
    }

    func add(
        child: UIViewController,
        using animator: LayoutAnimator,
        animated: Bool = true,
        then completion: LayoutAnimator.Completion? = nil
    ) {
        add(
            child: child,
            in: view,
            using: animator,
            animated: animated,
            then: completion
        )
    }

    func add(
        child: UIViewController,
        in container: UIView,
        using animator: LayoutAnimator,
        animated: Bool = true,
        then completion: LayoutAnimator.Completion? = nil
    ) {
        add(child: child, in: container)

        let context = ViewControllerLayoutContext(
            parent: self,
            child: child,
            container: container,
            animated: animated,
            presenting: true
        )

        animator.animate(in: context) {
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    func dropFromParent(
        using animator: LayoutAnimator,
        animated: Bool = true,
        then completion: LayoutAnimator.Completion? = nil
    ) {
        guard let parent = self.parent else {
            completion?()
            return
        }

        let context = ViewControllerLayoutContext(
            parent: parent,
            child: self,
            container: view.superview ?? parent.view,
            animated: animated,
            presenting: false
        )

        animator.animate(in: context) {
            DispatchQueue.main.async {
                self.dropFromParent()
                completion?()
            }
        }
    }
}

@objc public extension UINavigationController {
    typealias Action = () -> Void
    typealias Completion = () -> Void

    func with(delegate: UINavigationControllerDelegate, _ block: Action) {
        let currentDelegate = self.delegate
        self.delegate = delegate
        block()
        self.delegate = currentDelegate
    }

    func push(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: Completion? = nil
    ) {
        let action: Action = {
            self.pushViewController(controller, animated: animated)
        }

        perform(action: action, animated: animated, completion: completion)
    }

    func pop(animated: Bool = true, completion: Completion? = nil) {
        let action: Action = {
            self.popViewController(animated: animated)
        }

        perform(action: action, animated: animated, completion: completion)
    }

    func pop(
        to controller: UIViewController,
        animated: Bool = false,
        completion: Completion? = nil
    ) {
        let action: Action = {
            self.popToViewController(controller, animated: animated)
        }

        perform(action: action, animated: animated, completion: completion)
    }

    func popToRoot(animated: Bool = false, completion: Completion? = nil) {
        let action: Action = {
            self.popToRootViewController(animated: animated)
        }

        perform(action: action, animated: animated, completion: completion)
    }

    func perform(action: Action, animated: Bool, completion: Completion? = nil) {
        action()

        guard animated, let coordinator = transitionCoordinator else {
            completion?()
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
#endif
