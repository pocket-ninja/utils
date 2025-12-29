//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import UIKit

public final class UIBackdropView: UIVisualEffectView {
    private let animator = UIViewPropertyAnimator()
    
    public init() {
        super.init(effect: nil)
        animator.addAnimations { [weak self] in self?.effect = UIBlurEffect() }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
