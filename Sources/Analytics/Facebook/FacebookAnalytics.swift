//
//  Copyright © 2020 sroik. All rights reserved.
//

import FBSDKCoreKit
import Analytics

public final class FacebookAnalytics: AnalyticsDrain {
    public init() {}

    public func track(_ event: Event) {
        switch event {
        case let .plain(name, params, _):
            AppEvents.logEvent(
                AppEvents.Name(name),
                parameters: params
            )
            
        case let .purchase(_, _, params, price, priceLocale):
            AppEvents.logPurchase(
                NSDecimalNumber(decimal: price).doubleValue,
                currency: priceLocale.currencyCode ?? "",
                parameters: params
            )
            
        }
    }
}
