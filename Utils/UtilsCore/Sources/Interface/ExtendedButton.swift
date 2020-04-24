//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

open class ExtendedButton: UIButton {
    open var tapAreaInsets: UIEdgeInsets = .defaultButtonTapArea
    open var hightlightAlpha: CGFloat = 0.75

    open var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? hightlightAlpha : 1
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isExclusiveTouch = true
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds: CGRect = bounds.inset(by: tapAreaInsets)
        return extendedBounds.contains(point)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.shadowColor = shadowColor.cgColor
    }
}

public extension UIEdgeInsets {
    static var defaultButtonTapArea: UIEdgeInsets {
        return UIEdgeInsets(top: -15, left: -15, bottom: -15, right: -15)
    }
}
