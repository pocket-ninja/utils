//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

open class NavigationBarLabelItem: NavigationItem {
    open var view: UIView {
        return label
    }

    open var tintColor: UIColor? {
        didSet {
            tint(with: tintColor)
        }
    }

    open var disabledColor: UIColor = .darkGray {
        didSet {
            if state == .disabled {
                label.textColor = disabledColor
            }
        }
    }

    open var state: State = .enabled {
        didSet {
            label.textColor = state == .enabled ? tintColor : disabledColor
        }
    }

    public let label: UILabel

    public init(label: UILabel) {
        self.label = label
        self.tintColor = label.textColor
    }

    public init(title: String? = nil, color: UIColor? = nil, font: UIFont? = nil) {
        label = UILabel()
        label.text = title
        label.font = font
        label.textColor = color
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignCenters
        label.adjustsFontSizeToFitWidth = true
        tintColor = color
    }

    open func tint(with color: UIColor?) {
        if state == .enabled {
            label.textColor = color
        }
    }
}
#endif
