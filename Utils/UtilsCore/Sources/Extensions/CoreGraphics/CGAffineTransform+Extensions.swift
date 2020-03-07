//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
    typealias Scale = CGPoint

    var scale: Scale {
        return CGPoint(
            x: sqrt(a * a + c * c),
            y: sqrt(b * b + d * d)
        )
    }

    var rotation: CGFloat {
        return atan2(b, a)
    }

    var caTransform: CATransform3D {
        return CATransform3DMakeAffineTransform(self)
    }

    func translated(by: CGPoint) -> CGAffineTransform {
        return concatenating(CGAffineTransform(translationX: by.x, y: by.y))
    }

    func translated(to: CGPoint) -> CGAffineTransform {
        let diff = CGPoint(x: tx, y: ty).translation(to: to)
        return translated(by: diff)
    }
}
