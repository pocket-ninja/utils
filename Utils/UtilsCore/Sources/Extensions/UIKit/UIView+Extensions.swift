//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }
}
