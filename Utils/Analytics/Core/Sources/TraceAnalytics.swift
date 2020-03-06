//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UtilsCore

public final class TraceAnalytics: AnalyticsDrain {
    public init() {}

    public func track(_ event: Event) {
        trace("Analytics tracked event: \(event)")
    }
}
