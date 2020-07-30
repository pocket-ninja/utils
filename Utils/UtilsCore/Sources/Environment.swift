//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public class Environment {
    #if os(iOS)
        public static let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
        public static let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    #endif

    public static var isTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }

    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    public static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
