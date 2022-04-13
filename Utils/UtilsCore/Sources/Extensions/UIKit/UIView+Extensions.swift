//
//  Copyright © 2020 sroik. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }
    
    func anchor(
        in view: UIView,
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        width: NSLayoutDimension? = nil,
        height: NSLayoutDimension? = nil,
        widthConstant: CGFloat? = nil,
        heightConstant: CGFloat? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        topOffset: CGFloat = 0,
        leftOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0,
        rightOffset: CGFloat = 0,
        insets: UIEdgeInsets = .zero
    ) {
        removeFromSuperview()
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            let constant = topOffset + insets.top
            topAnchor.constraint(equalTo: top, constant: constant).isActive = true
        }

        if let left = left {
            let constant = leftOffset + insets.left
            leftAnchor.constraint(equalTo: left, constant: constant).isActive = true
        }

        if let bottom = bottom {
            let constant = -(bottomOffset + insets.bottom)
            bottomAnchor.constraint(equalTo: bottom, constant: constant).isActive = true
        }

        if let right = right {
            let constant = -(rightOffset + insets.right)
            rightAnchor.constraint(equalTo: right, constant: constant).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalTo: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalTo: height).isActive = true
        }
        
        if let const = widthConstant {
            widthAnchor.constraint(equalToConstant: const).isActive = true
        }

        if let const = heightConstant {
            heightAnchor.constraint(equalToConstant: const).isActive = true
        }

        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    func fill(in view: UIView, insets: UIEdgeInsets = .zero) {
        anchor(
            in: view,
            top: view.topAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            insets: insets
        )
    }
}
#endif
