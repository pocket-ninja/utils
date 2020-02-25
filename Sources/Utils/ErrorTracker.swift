//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol AnalyticsError {
    var domain: String { get }
    var code: Int { get }
    var parameters: [String: String] { get }
}

public protocol ErrorTracker {
    func track(_ error: AnalyticsError)
}

public extension AnalyticsError {
    var localizedDescription: String {
        return domain
    }
    
    var nsError: NSError {
        return NSError(
            domain: domain,
            code: code,
            userInfo: parameters
        )
    }
}

public var errorTracker: ErrorTracker?
