//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

#if os(iOS)
public enum TabBarItemState {
    case selected
    case normal
}

public protocol TabBarItemViewable: UIView {
    typealias TapHandler = (TabBarItemViewable) -> Void
    
    var state: TabBarItemState { get set }
    var tapHandler: TapHandler? { get set }
}
#endif
