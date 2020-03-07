//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol TimerScheduler {
    func add(_ timer: Timer, forMode: RunLoop.Mode)
}

extension RunLoop: TimerScheduler {}
