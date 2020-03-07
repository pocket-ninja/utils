//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class ActionTarget<C: UIControl> {
    public typealias Callback = (C) -> Void

    public init(callback: @escaping Callback) {
        self.callback = callback
    }

    @objc public func performAction(_ caller: Any) {
        guard let castedCaller = caller as? C else {
            assertionWrapperFailure("wrong caller type")
            return
        }

        callback(castedCaller)
    }

    private let callback: Callback
}

public extension UIControl {
    func subscribe(to event: UIControl.Event, with callback: @escaping () -> Void) -> Token {
        return subscribe(to: event) { (_: UIControl) in
            callback()
        }
    }

    func subscribe<C: UIControl>(to event: UIControl.Event, with callback: @escaping ActionTarget<C>.Callback) -> Token {
        let target = ActionTarget<C>(callback: callback)
        addTarget(target, action: #selector(ActionTarget<C>.performAction(_:)), for: event)

        return DeinitToken { [weak self] in
            self?.removeTarget(target, action: #selector(ActionTarget<C>.performAction(_:)), for: event)
        }
    }
}
