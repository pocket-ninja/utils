//
//  Copyright © 2022 sroik. All rights reserved.
//

import Foundation
import UtilsCore

do {
    let nilValue: Int? = nil
    _ = try nilValue.get()
} catch {
    print("utils core works perfect in cli 👍")
    print(BitmapBackground.color(nil))
}
