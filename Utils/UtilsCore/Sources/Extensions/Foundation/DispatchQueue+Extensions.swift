//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    func after(_ delay: Double, execute block: @escaping () -> Void) {
        let deadline = DispatchTime.now() + delay
        asyncAfter(deadline: deadline, execute: block)
    }
}

public func after(_ delay: TimeInterval, execute block: @escaping () -> Void) {
    DispatchQueue.main.after(delay, execute: block)
}
