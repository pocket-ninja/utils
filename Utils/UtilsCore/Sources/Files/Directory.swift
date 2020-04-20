//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public enum Directory: String, Codable, Hashable {
    case caches
    case documents
    case temporary
}

public extension Directory {
    var path: String {
        switch self {
        case .temporary:
            return NSTemporaryDirectory()
        case .documents:
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        case .caches:
            return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        }
    }
}
