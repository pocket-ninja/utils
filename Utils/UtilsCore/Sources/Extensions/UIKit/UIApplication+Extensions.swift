//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIApplication {
    public var activeWindow: UIWindow? {
        foregroundWindowScene?.windows.first { $0.isKeyWindow }
    }
    
    public var foregroundWindowScene: UIWindowScene? {
        foregroundScene as? UIWindowScene
    }
    
    public var topViewController: UIViewController? {
        activeWindow?.rootViewController?.topPresentedViewController
    }
    
    public var foregroundScene: UIScene? {
        connectedScenes.first {
            switch $0.activationState {
            case .foregroundActive, .foregroundInactive:
                return true
            default:
                return false
            }
        }
    }
    
    public func change(interfaceStyle: UIUserInterfaceStyle) {
        connectedScenes.forEach { scene in
            (scene as? UIWindowScene)?.windows.forEach { window in
                window.overrideUserInterfaceStyle = interfaceStyle
            }
        }
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
#endif
