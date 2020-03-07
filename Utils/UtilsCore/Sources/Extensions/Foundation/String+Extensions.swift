//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension String {
    static var empty: String {
        return ""
    }
    
    func substring(from: Int, to: Int) -> String {
        guard to >= from else {
            return .empty
        }

        let range = (from ..< to + 1).clamped(to: 0 ..< count)
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
}
