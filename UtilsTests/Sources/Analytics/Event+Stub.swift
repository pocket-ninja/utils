//
//  Copyright © 2020 sroik. All rights reserved.
//

import Analytics

extension Event {
    static let shot: Event = .plain(name: "Shot")
    static let unique: Event = .plain(name: "Unique", unique: true)
}
