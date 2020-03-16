//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UtilsCore

public protocol AnalyticsDrain {
    func track(_ event: AnalyticsEvent)
}
