//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UIFont {
    static func system(size: CGFloat, weight: Weight) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }
    
    static func thin(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .thin)
    }

    static func light(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .light)
    }

    static func regular(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .regular)
    }

    static func medium(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .medium)
    }

    static func semibold(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .semibold)
    }

    static func bold(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .bold)
    }

    static func heavy(size: CGFloat) -> UIFont {
        return .system(size: size, weight: .heavy)
    }
}
