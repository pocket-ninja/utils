//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol TabBarViewable: UIView {
    associatedtype ItemView: TabBarItemViewable
    
    var items: [ItemView] { get set }
    var height: CGFloat { get }
    var onSelect: (ItemView, Int) -> Void { get set }
    func selectItem(at index: Int, animated: Bool)
}
#endif
