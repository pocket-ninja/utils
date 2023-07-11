//
//  Copyright © 2023 sroik. All rights reserved.
//

import UIKit
import SwiftUI
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
        window?.rootViewController = UIHostingController(rootView: DemoView())
        window?.makeKeyAndVisible()
        
        return true
    }
}
