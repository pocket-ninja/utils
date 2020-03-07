//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

extension Bool {
    typealias Job = () throws -> Void

    func onTrue(do job: Job) rethrows {
        if self == true {
            try job()
        }
    }

    func onFalse(do job: Job) rethrows {
        if self == false {
            try job()
        }
    }
}
