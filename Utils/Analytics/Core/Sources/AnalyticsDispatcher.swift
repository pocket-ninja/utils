//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UtilsCore

final class AnalyticsDispatcher {
    init(storage: Storage) {
        self.storage = storage
    }

    func once(for key: String, action: () -> Void) {
        synchronized(self) {
            if storage.bool(forKey: key) == true {
                return
            }

            storage.set(true, forKey: key)
            action()
        }
    }

    private let storage: Storage
}
