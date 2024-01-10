//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public struct TabBarItem<ItemView: TabBarItemViewable>: Identifiable {
    public let id: String
    public var viewController: UIViewController
    public var itemView: ItemView

    public init(id: ID, viewController: UIViewController, itemView: ItemView) {
        self.id = id
        self.viewController = viewController
        self.itemView = itemView
    }
}
#endif
