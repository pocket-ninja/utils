//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    static func * (l: UIEdgeInsets, by: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: l.top * by,
            left: l.left * by,
            bottom: l.bottom * by,
            right: l.right * by
        )
    }

    static func + (l: UIEdgeInsets, r: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: l.top + r.top,
            left: l.left + r.left,
            bottom: l.bottom + r.bottom,
            right: l.right + r.right
        )
    }

    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return left + right
    }

    init(repeated value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }

    init(top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }

    func inset(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width - horizontal, height: size.height - vertical)
    }

    func inset(_ rect: CGRect) -> CGRect {
        return rect.inset(by: self)
    }
}
