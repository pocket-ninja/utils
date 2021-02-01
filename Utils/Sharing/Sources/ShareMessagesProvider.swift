//
//  Copyright © 2021 pocket-ninja. All rights reserved.
//

import UIKit
import MessageUI

public final class ShareMessagesProvider: NSObject, MFMessageComposeViewControllerDelegate {
    public typealias Completion = (Bool) -> Void
    
    public func share(
        content: ShareContent,
        in controller: UIViewController,
        then completion: @escaping Completion
    ) {
        let messagesController = MFMessageComposeViewController()
        messagesController.messageComposeDelegate = self
        messagesController.body = content.caption
        
        switch content.item {
        case let .file(url):
            messagesController.addAttachmentURL(
                url,
                withAlternateFilename: nil
            )
            
        case let .image(image):
            if let data = image.pngData() {
                messagesController.addAttachmentData(
                    data,
                    typeIdentifier: "image/png",
                    filename: "image.png"
                )
            }
        }
        
        controller.present(messagesController, animated: true, completion: nil)
        self.completion = completion
    }
    
    public func messageComposeViewController(
        _ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult
    ) {
        controller.dismiss(animated: true) {
            self.completion?(result == MessageComposeResult.sent)
            self.completion = nil
        }
    }
    
    private var completion: Completion?
}
