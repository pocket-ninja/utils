//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public final class ShareService {
    public static let shared = ShareService()

    private lazy var messagesProvider = ShareMessagesProvider()
    
    public func shareViaActivity(
        content: ShareContent,
        in sourceViewController: UIViewController,
        from rect: CGRect = .zero,
        then completion: @escaping ShareActivityProvider.Completion
    ) {
        ShareActivityProvider.share(
            content: content,
            in: sourceViewController,
            from: rect,
            then: completion
        )
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
}
