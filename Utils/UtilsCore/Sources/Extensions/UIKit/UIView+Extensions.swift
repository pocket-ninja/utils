//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }

    func subscribeToTaps(ofCount tapsCount: Int = 1, with action: @escaping () -> Void) -> Token {
        let action = GestureTarget(states: [.ended]) { _ in
            action()
        }

        let gesture = UITapGestureRecognizer(target: action, action: #selector(action.gestureAction(_:)))
        gesture.numberOfTapsRequired = tapsCount
        addGestureRecognizer(gesture)

        return DeinitToken { [weak self] in
            self?.removeGestureRecognizer(gesture)
            _ = action
        }
    }
}
