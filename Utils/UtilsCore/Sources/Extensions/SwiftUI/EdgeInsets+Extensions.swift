//
//  Copyright © 2023 sroik. All rights reserved.
//

import SwiftUI

public extension EdgeInsets {
    init(repeated value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}
