//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

extension UIApplication {
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
