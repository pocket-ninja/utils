//
//  Copyright © 2020 sroik. All rights reserved.
//

import CoreGraphics
import Foundation

public extension CGAffineTransform {
    typealias Scale = CGPoint

    var absScale: Scale {
        signScale.abs
    }
    
    var signScale: Scale {
        return CGPoint(
            x: sqrt(a * a + c * c) * (a >= 0 ? 1 : -1),
            y: sqrt(b * b + d * d) * (d >= 0 ? 1 : -1)
        )
    }

    var rotation: CGFloat {
        return atan2(b, a)
    }

    func translated(by: CGPoint) -> CGAffineTransform {
        return concatenating(CGAffineTransform(translationX: by.x, y: by.y))
    }

    func translated(to: CGPoint) -> CGAffineTransform {
        let diff = CGPoint(x: tx, y: ty).translation(to: to)
        return translated(by: diff)
    }
}
