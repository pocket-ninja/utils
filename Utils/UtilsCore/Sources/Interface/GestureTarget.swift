//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class GestureTarget {
    public typealias Action = (UIGestureRecognizer) -> Void

    public init(states: [UIGestureRecognizer.State], oneShot: Bool = false, action: @escaping Action) {
        self.states = states
        self.isOneShot = oneShot
        self.action = action
    }

    @objc public func gestureAction(_ gesture: UIGestureRecognizer) {
        if states.contains(gesture.state) {
            action(gesture)
        }

        if isOneShot, gesture.isEnabled {
            gesture.isEnabled = false
            gesture.isEnabled = true
        }
    }

    private let action: Action
    private let states: [UIGestureRecognizer.State]
    private let isOneShot: Bool
}
