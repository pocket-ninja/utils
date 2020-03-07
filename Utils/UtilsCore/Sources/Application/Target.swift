//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public class Target {
    public let version: String
    public let build: String
    public let name: String
    public let displayName: String

    public init(bundle: Bundle) {
        let bundleName = bundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
        displayName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? bundleName
        version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String ?? ""
        build = bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
        name = bundleName
    }
}

public extension Target {
    static var current: Target {
        return Target(bundle: .main)
    }
}
