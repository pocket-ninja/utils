//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol ErrorTracker {
    func track(_ error: NSError)
}

public var errorTracker: ErrorTracker?
