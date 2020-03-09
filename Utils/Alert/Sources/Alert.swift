//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public final class Alert: NSObject {
    public typealias Callback = () -> Void
    public typealias OptionCallback = (Bool) -> Void

    #warning("translate")
    public static func ok(
        title: String? = nil,
        message: String? = nil,
        callback: Callback? = nil
    ) -> UIAlertController {
        #warning("localize")
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default) { _ in callback?() }
        controller.addAction(okAction)
        return controller
    }

    public static func option(
        title: String? = nil,
        message: String? = nil,
        positive: String? = nil,
        negative: String? = nil,
        callback: @escaping OptionCallback
    ) -> UIAlertController {
        let controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        #warning("localize")
        let positiveAction = UIAlertAction(title: positive ?? "yes", style: .default) { _ in
            callback(true)
        }

        #warning("localize")
        let negativeAction = UIAlertAction(title: negative ?? "no", style: .default) { _ in
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

        #warning("localize")
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { _ in
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

        #warning("localize")
        return option(
            title: title,
            message: message,
            positive: "settings",
            negative: "cancel",
            callback: controllerCallback
        )
    }
}

extension Alert {
    #warning("fix")
//    public static func purchaseRetry(callback: @escaping OptionCallback) -> UIAlertController {
//        return option(
//            title: R.string.general.oops(),
//            message: R.string.general.somethingWentWrong(),
//            positive: R.string.general.retry(),
//            negative: R.string.general.cancel(),
//            callback: callback
//        )
//    }
//
//    public static func noRestoredItems() -> UIAlertController {
//        return ok(message: R.string.general.noItemsToRestore())
//    }
//
//    public static func oopsError() -> UIAlertController {
//        return ok(title: R.string.general.oops(), message: R.string.general.somethingWentWrong())
//    }
//
//    public static func noInternet() -> UIAlertController {
//        return ok(message: R.string.general.noInternet())
//    }
}

