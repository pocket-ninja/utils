//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UtilsCore

public class Analytics: AnalyticsDrain {
    public var isEnabled: Bool = false

    public init(storage: Storage = UserDefaults.standard, drains: [AnalyticsDrain]) {
        self.dispatcher = AnalyticsDispatcher(storage: storage)
        self.drain = CompositeAnalytics(drains: drains)
    }

    public func track(_ event: Event) {
        guard isEnabled else {
            return
        }

        let track = {
            self.drain.track(event)
        }

        event.unique ?
            dispatcher.once(for: event.oneShotKey, action: track) :
            track()
    }

    private let dispatcher: AnalyticsDispatcher
    private let drain: AnalyticsDrain
}

public extension AnalyticsDrain {
    var app: Analytics? {
        return self as? Analytics
    }
}
