//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public enum Event: Hashable {
    public typealias Params = [String: String]

    public enum PurchaseType: String, Codable, Hashable {
        case subscription
    }

    case plain(
        name: String,
        params: Params = [:],
        unique: Bool = false
    )
    
    case purchase(
        id: String,
        type: PurchaseType,
        params: Params = [:],
        price: Decimal,
        priceLocale: Locale
    )
}

extension Event: OneShotable {
    var unique: Bool {
        switch self {
        case let .plain(_, _ , unique):
            return unique
        case .purchase:
            return false
        }
    }
    
    var oneShotKey: String {
        switch self {
        case let .plain(name, _ , _):
            return "disposable_event_\(name)"
        case let .purchase(id, _ , _, _, _):
            return "disposable_event_\(id)"

        }
    }
}
