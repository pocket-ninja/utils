//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol AnalyticsDrain {
    func track(_ event: Event)
}
