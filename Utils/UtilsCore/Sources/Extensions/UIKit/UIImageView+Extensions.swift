//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UIImageView {
    func set(image: UIImage?, animated: Bool = true, fadeDuration: TimeInterval = 0.15) {
        guard animated, image != nil else {
            self.image = image
            return
        }

        self.image = image
        let transition = CATransition()
        transition.duration = fadeDuration
        layer.add(transition, forKey: nil)
    }
}
#endif
