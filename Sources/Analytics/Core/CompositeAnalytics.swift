//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public final class CompositeAnalytics: AnalyticsDrain {
    public init(drains: [AnalyticsDrain]) {
        self.drains = drains
    }

    public func track(_ event: Event) {
        drains.forEach { $0.track(event) }
    }

    private let drains: [AnalyticsDrain]
}
