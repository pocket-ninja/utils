//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol TabBarViewDelegate: AnyObject {
    func tabBarView(_ view: TabBarViewable, tappedOn: TabBarItemViewable, at index: Int)
}

public protocol TabBarViewable: UIView {
    var delegate: TabBarViewDelegate? { get set }
    var items: [TabBarItemViewable] { get set }
    var height: CGFloat { get }
    func selectItem(at index: Int, animated: Bool)
}
#endif
