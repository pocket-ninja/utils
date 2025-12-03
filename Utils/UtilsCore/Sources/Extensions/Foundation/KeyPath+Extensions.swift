//
//  Copyright © 2025 sroik. All rights reserved.
//

import Foundation

extension PartialKeyPath {
    var property: String {
        let description = String(describing: self)
        return description.components(separatedBy: ".").last ?? description
    }
}
