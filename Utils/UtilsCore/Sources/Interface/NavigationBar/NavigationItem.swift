//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

#if os(iOS)
public enum NavigationItemState {
    case enabled
    case disabled
}

public protocol NavigationItem {
    typealias State = NavigationItemState

    var view: UIView { get }
    var tintColor: UIColor? { get set }
    var state: State { get set }

    /* tint all elements. Don't touch tintColor property in this func */
    func tint(with color: UIColor?)
}
#endif
