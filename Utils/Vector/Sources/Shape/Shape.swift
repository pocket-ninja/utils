//
//  Copyright © 2020 sroik. All rights reserved.
//

import CoreGraphics

public struct Shape: Hashable, Identifiable {
    public let id: Int
    public var path: CGPath
    public var style: ShapeStyle

    public init(
        id: ID,
        path: CGPath,
        style: ShapeStyle
    ) {
        self.id = id
        self.path = path
        self.style = style
    }
}
