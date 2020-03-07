//
//  Copyright © 2020 sroik. All rights reserved.
//

import StoreKit
import UIKit

public protocol RateReviewController {
    func requestReview()
}

public final class StoreKitRateReviewController: RateReviewController {
    public init() {}

    public func requestReview() {
        SKStoreReviewController.requestReview()
    }
}

public struct RateReviewConfig {
    public var storage: Storage
    public var domain: String
    public var eventsPerRate: UInt

    public init(
        storage: Storage = UserDefaults.standard,
        domain: String = "com.sroik.rate_review_count",
        eventsPerRate: UInt = 4
    ) {
        self.storage = storage
        self.domain = domain
        self.eventsPerRate = eventsPerRate
    }
}

public final class RateReviewService {
    public init(
        config: RateReviewConfig = RateReviewConfig(),
        controller: RateReviewController = StoreKitRateReviewController()
    ) {
        self.config = config
        self.controller = controller
        self.persistentCounter = PersistentCounter(storage: config.storage, domain: config.domain)
    }

    @discardableResult
    public func requestReview() -> Bool {
        let shouldRequest = shouldRequestReview()
        persistentCounter?.increase()

        guard shouldRequest else {
            return false
        }

        controller.requestReview()
        return true
    }

    private func shouldRequestReview() -> Bool {
        guard let counter = persistentCounter else {
            assertionWrapperFailure("rr messanger has nil persistent counter")
            return false
        }

        return counter.count % config.eventsPerRate == 0
    }

    private let config: RateReviewConfig
    private let controller: RateReviewController
    private let persistentCounter: PersistentCounter?
}
