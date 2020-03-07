//
//  Copyright © 2020 sroik. All rights reserved.
//

import UtilsCore

final class StorageMock: Storage {
    var values: [String:Any] = [:]

    func value(forKey key: String) -> Any? {
        return values[key]
    }

    func set(_ value: Any?, forKey key: String) {
        if let value = value {
            values[key] = value
        } else {
            values.removeValue(forKey: key)
        }
    }
}
