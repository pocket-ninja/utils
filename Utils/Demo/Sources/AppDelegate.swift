//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard Environment.isTests == false else {
            return false
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DemoViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
