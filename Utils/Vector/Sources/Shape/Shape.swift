//
//  Copyright © 2020 sroik. All rights reserved.
//

import CoreGraphics

public typealias ShapeIdentifier = Int

public struct Shape: Hashable {
    public let identifier: ShapeIdentifier
    public var index: Int
    public var path: CGPath
    public var style: ShapeStyle

    public init(
        identifier: ShapeIdentifier,
        index: Int,
        path: CGPath,
        style: ShapeStyle
    ) {
        self.identifier = identifier
        self.index = index
        self.path = path
        self.style = style
    }
}
