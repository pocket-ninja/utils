//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public final class IconTabBarItemView: UIView, TabBarItemViewable {
    public var badgeView: UIView? {
        didSet {
            if let view = oldValue, view.superview == self {
                view.removeFromSuperview()
            }

            renderBadge()
        }
    }

    public var icon: UIImage? {
        get {
            iconView.image
        }

        set {
            iconView.image = newValue
        }
    }

    public var title: String? {
        get {
            titleLabel.text
        }

        set {
            titleLabel.text = newValue
        }
    }

    public var font: UIFont? {
        get {
            titleLabel.font
        }

        set {
            titleLabel.font = newValue
        }
    }

    public var color: UIColor = .white {
        didSet {
            renderState()
        }
    }

    public var state: TabBarItemState = .normal {
        didSet {
            renderState()
        }
    }

    public var tapHandler: TapHandler?

    public init(title: String? = nil, icon: UIImage? = nil, badge: UIView? = nil) {
        self.badgeView = badge
        super.init(frame: .zero)
        self.icon = icon
        self.title = title
        self.isAccessibilityElement = true
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        addSubviews(iconView, titleLabel)

        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            iconView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)

        renderState()
        renderBadge()
    }
    
    @objc private func handleTap() {
        tapHandler?(self)
    }

    public func renderState() {
        let tint = state == .normal ? color.withAlphaComponent(0.6) : color
        iconView.tintColor = tint
        titleLabel.textColor = tint
    }

    private func renderBadge() {
        guard let badge = badgeView else {
            return
        }

        addSubview(badge)
        badge.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badge.centerYAnchor.constraint(equalTo: iconView.topAnchor, constant: 2.5),
            badge.centerXAnchor.constraint(equalTo: iconView.rightAnchor)
        ])
    }

    private let titleLabel = UILabel()
    private let iconView = UIImageView()
}
#endif
