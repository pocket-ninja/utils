//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

#if os(iOS)
open class NavigationBar: UIView {
    public typealias Item = NavigationItem
    public typealias ButtonItem = NavigationBarButtonItem
    public typealias ViewItem = NavigationBarViewItem
    public typealias LabelItem = NavigationBarLabelItem

    public enum Background {
        case color(UIColor)
        case blur(UIBlurEffect.Style)
    }

    open var passInsideTouches = true

    open var background: Background = .color(.white) {
        didSet {
            updateBackground()
        }
    }

    open var titleItem: Item? {
        didSet {
            oldValue?.view.removeFromSuperview()
            layoutItems()
        }
    }

    open var leftItem: Item? {
        didSet {
            oldValue?.view.removeFromSuperview()
            layoutItems()
        }
    }

    open var rightItem: Item? {
        didSet {
            oldValue?.view.removeFromSuperview()
            layoutItems()
        }
    }

    open var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) {
        didSet {
            layoutItems()
        }
    }

    open var minimumItemSpacing: CGFloat = 10 {
        didSet {
            layoutItems()
        }
    }

    open var separatorColor: UIColor? {
        get {
            return separator.backgroundColor
        }
        set {
            separator.backgroundColor = newValue
        }
    }

    open var titleColor: UIColor? {
        get {
            return titleItem?.tintColor
        }
        set {
            titleItem?.tintColor = newValue
        }
    }

    open override var tintColor: UIColor? {
        didSet {
            syncTintColor()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard bounds.contains(point) else {
            return false
        }

        guard passInsideTouches else {
            return true
        }

        for view in [titleItem, leftItem, rightItem].compactMap({ $0?.view }) {
            if view.point(inside: convert(point, to: view), with: event) {
                return true
            }
        }

        return false
    }

    open func syncTintColor() {
        [leftItem, rightItem, titleItem].compactMap { $0 }.forEach { item in
            if item.tintColor == nil {
                item.tint(with: tintColor)
            }
        }
    }

    private func setup() {
        tintColor = .black
        effectsView.fill(in: self)
        separator.anchor(
            in: self,
            bottom: bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            heightConstant: 1
        )

        layoutItems()
        updateBackground()
    }

    private func updateBackground() {
        switch background {
        case let .color(color):
            effectsView.effect = nil
            backgroundColor = color
        case let .blur(style):
            effectsView.effect = UIBlurEffect(style: style)
            backgroundColor = .clear
        }
    }

    private func layoutItems() {
        let heightOffset = -(contentInsets.top + contentInsets.bottom)
        let centerYOffset = (contentInsets.top - contentInsets.bottom) / 2

        if let titleView = titleItem?.view {
            titleView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            titleView.anchor(in: self)
            
            NSLayoutConstraint.activate([
                titleView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: heightOffset),
                titleView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYOffset),
                titleView.centerXAnchor.constraint(equalTo: centerXAnchor).set(\.priority, to: .defaultLow),
                titleView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: contentInsets.left),
                titleView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -contentInsets.right)
            ])
        }

        if let leftView = leftItem?.view {
            leftView.setContentCompressionResistancePriority(.required, for: .horizontal)
            leftView.anchor(in: self)
            
            NSLayoutConstraint.activate([
                leftView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: heightOffset),
                leftView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYOffset),
                leftView.leftAnchor.constraint(equalTo: leftAnchor, constant: contentInsets.left),
                leftView.rightAnchor.constraint(
                    lessThanOrEqualTo: titleItem?.view.leftAnchor ?? rightAnchor,
                    constant: -minimumItemSpacing
                )
            ])
        }

        if let rightView = rightItem?.view {
            rightView.setContentCompressionResistancePriority(.required, for: .horizontal)
            rightView.anchor(in: self)
            NSLayoutConstraint.activate([
                rightView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: heightOffset),
                rightView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYOffset),
                rightView.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentInsets.right),
                rightView.leftAnchor.constraint(
                    greaterThanOrEqualTo: titleItem?.view.rightAnchor ?? leftAnchor,
                    constant: minimumItemSpacing
                )
            ])
        }

        [titleItem, leftItem, rightItem].forEach { $0?.view.layoutIfNeeded() }
        syncTintColor()
    }

    private let separator = UIView()
    private let effectsView = UIVisualEffectView()
}
#endif
