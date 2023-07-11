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
        messagesController.subject = content.subject
        
        switch content.item {
        case let .text(text):
            messagesController.body = text
            
        case let .file(url):
            messagesController.addAttachmentURL(url, withAlternateFilename: nil)
            
        case let .files(urls):
            urls.forEach {
                messagesController.addAttachmentURL($0, withAlternateFilename: nil)
            }
            
        case let .image(image, compression):
            if let data = image.data(compression: compression) {
                messagesController.addAttachmentData(
                    data,
                    typeIdentifier: "image/\(compression.ext)",
                    filename: "image.\(compression.ext)"
                )
            }
        case let .data(data, type):
            messagesController.addAttachmentData(
                data,
                typeIdentifier: type.identifier,
                filename: "file.\(type.preferredFilenameExtension ?? "data")"
            )
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
