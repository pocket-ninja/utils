//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public struct ShareService {
    public typealias Content = ShareContent
    public typealias Completion = (Bool, UIActivity.ActivityType?) -> Void

    public static func shareViaActivity(
        content: Content,
        in sourceViewController: UIViewController,
        from rect: CGRect = .zero,
        then completion: @escaping Completion
    ) {
        let items: [Any?] = [content.item.value, content.caption]
        let activityController = UIActivityViewController(
            activityItems: items.compactMap { $0 },
            applicationActivities: []
        )

        if let subject = content.subject {
            activityController.setValue(subject, forKey: "subject")
        }

        activityController.completionWithItemsHandler = { activityType, success, _, _ in
            completion(success, activityType)
        }

        if UIDevice.current.userInterfaceIdiom == .pad {
            activityController.popoverPresentationController?.sourceView = sourceViewController.view
            activityController.popoverPresentationController?.permittedArrowDirections = .any
            activityController.popoverPresentationController?.sourceRect = rect
        }

        sourceViewController.present(activityController, animated: true)
    }
}
