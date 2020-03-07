//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

class BundleClassStub {}

extension Bundle {
    static var test: Bundle {
        return Bundle(for: BundleClassStub.self)
    }
}
