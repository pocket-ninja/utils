//
//  Copyright © 2023 sroik. All rights reserved.
//

import UIKit

 public struct ShareActivityProvider {
     public typealias Completion = (Bool, UIActivity.ActivityType?) -> Void
     
     public static func share(
         content: ShareContent,
         in sourceViewController: UIViewController,
         from rect: CGRect = .zero,
         then completion: @escaping Completion
     ) {
         let items: [Any?] = content.item.activityValues + [content.caption]
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

private extension ShareItem {
    var activityValues: [Any] {
        switch self {
        case let .image(image, compression):
            return [image.data(compression: compression) ?? image]
        case let .data(data, _):
            return [data]
        case let .files(files):
            return files.map { $0.url }
        case let .text(text):
            return [text]
        }
    }
}
