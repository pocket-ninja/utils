//
//  Copyright © 2023 sroik. All rights reserved.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func hidden(_ condition: Bool) -> some View {
        if condition {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func optional(size: CGSize?) -> some View {
        if let size {
            self.frame(width: size.width, height: size.height)
        } else {
            self
        }
    }
    
#if os(iOS)
    @available(iOS 15.0, *)
    @discardableResult
    func present(
        in parent: UIViewController? = UIApplication.shared.topViewController,
        animated: Bool = true,
        style: UIModalPresentationStyle = .formSheet,
        transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
        background: UIColor = UIColor.systemBackground,
        hasSheetGrabber: Bool = false,
        preferredCornerRadius: CGFloat? = nil,
        detents: [UISheetPresentationController.Detent] = [.large()],
        isModal: Bool = false,
        safeAreaRegions: SafeAreaRegions = .all,
        then completion: @escaping () -> Void = {}
    ) -> UIHostingController<Self> {
        
        let controller = BaseHostingController(rootView: self)
        controller.isModalInPresentation = isModal
        controller.strongTransitioningDelegate = transitioningDelegate
        controller.modalTransitionStyle = .coverVertical
        controller.modalPresentationStyle = style
        controller.view.backgroundColor = background
        
        if #available(iOS 16.4, *) {
            controller.safeAreaRegions = safeAreaRegions
        }
        
        if let sheet = controller.sheetPresentationController {
            sheet.prefersGrabberVisible = hasSheetGrabber
            sheet.preferredCornerRadius = preferredCornerRadius
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.detents = detents
        }
        
        guard let parentController = parent else {
            assertionWrapperFailure("no parent to present view from")
            return controller
        }
        
        parentController.present(controller, animated: animated, completion: completion)
        return controller
    }
#endif
}
