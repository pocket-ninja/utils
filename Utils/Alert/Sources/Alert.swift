//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class Alert: NSObject {
    public typealias Callback = () -> Void
    public typealias OptionCallback = (Bool) -> Void

    public static func ok(
        title: String? = nil,
        message: String? = nil,
        action: String,
        callback: Callback? = nil
    ) -> UIAlertController {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: action, style: .default) { _ in callback?() }
        controller.addAction(okAction)
        return controller
    }

    public static func option(
        title: String? = nil,
        message: String? = nil,
        positive: String,
        negative: String,
        callback: @escaping OptionCallback
    ) -> UIAlertController {
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let positiveAction = UIAlertAction(title: positive, style: .default) { _ in
            callback(true)
        }

        let negativeAction = UIAlertAction(title: negative, style: .default) { _ in
            callback(false)
        }

        controller.addAction(negativeAction)
        controller.addAction(positiveAction)
        controller.preferredAction = positiveAction
        return controller
    }

    public static func optionSheet(
        title: String? = nil,
        message: String? = nil,
        action: String,
        cancel: String,
        callback: @escaping OptionCallback
    ) -> UIAlertController {
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        let action = UIAlertAction(title: action, style: .destructive) { _ in
            callback(true)
        }

        let cancelAction = UIAlertAction(title: cancel, style: .cancel) { _ in
            callback(false)
        }

        controller.addAction(action)
        controller.addAction(cancelAction)
        controller.preferredAction = cancelAction
        return controller
    }

    public static func settings(
        title: String? = nil,
        message: String? = nil,
        positive: String,
        negative: String,
        callback: OptionCallback? = nil
    ) -> UIAlertController {
        let controllerCallback: OptionCallback = { isPositive in
            callback?(isPositive)

            guard
                isPositive,
                let url = URL(string: UIApplication.openSettingsURLString),
                UIApplication.shared.canOpenURL(url)
            else {
                return
            }
            
            UIApplication.shared.open(
                url,
                options: [:],
                completionHandler: nil
            )
        }

        return option(
            title: title,
            message: message,
            positive: positive,
            negative: negative,
            callback: controllerCallback
        )
    }
}
