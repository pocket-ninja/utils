//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public struct AnalyticsError: Codable, Hashable {
    public let domain: String
    public let code: Int
    public let parameters: [String: String]
    
    public init(domain: String, code: Int = 1, parameters: [String: String] = [:]) {
        self.domain = domain
        self.code = code
        self.parameters = parameters
    }
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
