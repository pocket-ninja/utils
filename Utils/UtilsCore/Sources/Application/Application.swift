//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol Application {
    var title: String { get }
    var scheme: URL { get }
    var storeUrl: URL { get }
}

public protocol OSAssistant {
    func isInstalled(_ app: Application) -> Bool
    @discardableResult func redirect(to app: Application) -> Bool
    @discardableResult func openAppStorePage(of app: Application) -> Bool
}

extension UIApplication: OSAssistant {
    public func isInstalled(_ app: Application) -> Bool {
        return canOpenURL(app.scheme)
    }

    @discardableResult
    public func openAppStorePage(of app: Application) -> Bool {
        return redirect(to: app.storeUrl)
    }

    @discardableResult
    public func redirect(to app: Application) -> Bool {
        return redirect(to: app.scheme)
    }

    @discardableResult
    public func redirect(to url: URL) -> Bool {
        guard canOpenURL(url) else {
            return false
        }

        open(url, options: [:], completionHandler: nil)
        return true
    }

    @discardableResult
    public func redirectToSettings() -> Bool {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return false
        }

        return redirect(to: url)
    }
}
