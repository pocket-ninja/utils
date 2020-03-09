//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Analytics

public final class FacebookAnalyticsDrain: AnalyticsDrain {
    public init(tracksPurchases: Bool = true) {
        self.tracksPurchases = tracksPurchases
    }

    public func track(_ event: Event) {
        switch event {
        case let .plain(name, params, _):
            AppEvents.logEvent(
                AppEvents.Name(name),
                parameters: params
            )
            
        case let .purchase(_, _, params, price, priceLocale) where tracksPurchases:
            AppEvents.logPurchase(
                NSDecimalNumber(decimal: price).doubleValue,
                currency: priceLocale.currencyCode ?? "",
                parameters: params
            )
        case .error, .purchase:
            break
        }
    }
    
    private let tracksPurchases: Bool
}
