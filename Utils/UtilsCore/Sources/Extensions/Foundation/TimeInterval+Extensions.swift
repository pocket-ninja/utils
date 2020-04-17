//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static var day: TimeInterval {
        return 24 * hour
    }

    static var hour: TimeInterval {
        return 60 * minute
    }

    static var minute: TimeInterval {
        return 60
    }
}
