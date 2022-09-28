//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public final class ShareService {
    public typealias Content = ShareContent
    public typealias Completion = (Bool, UIActivity.ActivityType?) -> Void
    
    public static let shared = ShareService()
    
    public func shareViaActivity(
        content: Content,
        in sourceViewController: UIViewController,
        from rect: CGRect = .zero,
        then completion: @escaping Completion
    ) {
        let items: [Any?] = [content.item.activityValue, content.caption]
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
    
    public func shareToPhotos(
        content: ShareContent,
        then completion: @escaping SharePhotosProvider.Completion
    ) {
        SharePhotosProvider.share(
            content: content,
            then: completion
        )
    }
    
    public func shareToPhotos(
        content: ShareContent,
        album: String,
        then completion: @escaping SharePhotosProvider.Completion
    ) {
        SharePhotosProvider.share(
            content: content,
            to: album,
            then: completion
        )
    }
    
    public func shareToMessages(
        content: ShareContent,
        in controller: UIViewController,
        then completion: @escaping ShareMessagesProvider.Completion
    ) {
        messagesProvider.share(
            content: content,
            in: controller,
            then: completion
        )
    }
    
    private var messagesProvider = ShareMessagesProvider()
}
