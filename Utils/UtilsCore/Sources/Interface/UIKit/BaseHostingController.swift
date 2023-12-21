//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS) || os(tvOS)
import SwiftUI

open class BaseHostingController<Content: View>: UIHostingController<Content> {
    open var strongTransitioningDelegate: UIViewControllerTransitioningDelegate? {
        didSet {
            transitioningDelegate = strongTransitioningDelegate
        }
    }
}
#endif
