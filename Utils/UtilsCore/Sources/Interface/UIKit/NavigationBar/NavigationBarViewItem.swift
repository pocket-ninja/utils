//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

open class NavigationBarViewItem: NavigationItem {
    public typealias StateHandler = (NavigationBarViewItem, NavigationItemState) -> Void

    open var state: State = .enabled {
        didSet {
            stateHandler?(self, state)
        }
    }

    open var tintColor: UIColor? {
        didSet {
            tint(with: tintColor)
        }
    }

    public let view: UIView
    open var stateHandler: StateHandler?

    public init(view: UIView, stateHandler: StateHandler? = nil) {
        self.view = view
        self.stateHandler = stateHandler
    }

    open func tint(with color: UIColor?) {
        view.tintColor = color
    }
}
#endif
