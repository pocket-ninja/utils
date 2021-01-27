//
//  Copyright © 2020 sroik. All rights reserved.
//

import CoreGraphics
import Foundation

public extension CGAffineTransform {
    typealias Scale = CGPoint

    var absScale: Scale {
        scale.abs
    }
    
    var scale: Scale {
        return CGPoint(
            x: sqrt(a * a + c * c) * a.signum,
            y: sqrt(b * b + d * d) * d.signum
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
