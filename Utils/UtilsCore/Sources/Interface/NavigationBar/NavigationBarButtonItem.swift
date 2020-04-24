//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

open class NavigationBarButtonItem: NavigationItem {
    open var view: UIView {
        return button
    }

    public let button: ExtendedButton

    open var state: State {
        get {
            return button.isEnabled ? .enabled : .disabled
        }
        set {
            button.isEnabled = newValue == .enabled
        }
    }

    open var font: UIFont? {
        get {
            return button.titleLabel?.font
        }
        set {
            button.titleLabel?.font = newValue
        }
    }

    open var title: String? {
        get {
            return button.title(for: .normal)
        }
        set {
            button.setTitle(newValue, for: .normal)
        }
    }

    open var icon: UIImage? {
        get {
            return button.image(for: .normal)
        }
        set {
            button.setImage(newValue, for: .normal)
        }
    }

    open var highlightedIcon: UIImage? {
        get {
            return button.image(for: .highlighted)
        }
        set {
            button.setImage(newValue, for: .highlighted)
        }
    }

    open var tintColor: UIColor? {
        didSet {
            tint(with: tintColor)
        }
    }

    public init(
        type: UIButton.ButtonType = .system,
        icon: UIImage? = nil,
        highlightedIcon: UIImage? = nil,
        title: String? = nil,
        font: UIFont? = nil,
        target: Any? = nil,
        action: Selector? = nil
    ) {
        button = ExtendedButton(type: type)
        button.setTitle(title, for: .normal)
        button.setImage(icon, for: .normal)
        button.setImage(highlightedIcon, for: .highlighted)
        button.titleLabel?.font = font
        setup()

        if let t = target, let a = action {
            add(target: t, action: a)
        }
    }

    open func tint(with color: UIColor?) {
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
    }

    open func add(target: Any?, action: Selector, for controlEvents: UIControl.Event = .touchUpInside) {
        button.addTarget(target, action: action, for: controlEvents)
        button.isUserInteractionEnabled = true
    }

    open func remove(target: Any?, action: Selector, for controlEvents: UIControl.Event = .touchUpInside) {
        button.removeTarget(target, action: action, for: controlEvents)
        button.isUserInteractionEnabled = button.allTargets.count > 0
    }

    open func setup() {
        button.tapAreaInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        button.sizeToFit()
        button.setTitleColor(.darkGray, for: .disabled)
        button.isUserInteractionEnabled = false
    }
}
