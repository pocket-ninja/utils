//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIScreen {
    static var pixelSize: CGFloat {
        1.0 / main.scale
    }
    
    static var minSide: CGFloat {
        main.bounds.size.minSide
    }
    
    static var userInterfaceStyle: UIUserInterfaceStyle {
        main.traitCollection.userInterfaceStyle
    }
    
    static var hasNotch: Bool {
        safeAreInsets.top > 0
    }
    
    static var safeAreInsets: UIEdgeInsets {
        UIApplication.shared.activeWindow?.safeAreaInsets ?? .zero
    }

    static var isShort: Bool {
        main.bounds.height < 668
    }
    
    static var isThin: Bool {
        main.bounds.width < 376
    }
}
#endif
