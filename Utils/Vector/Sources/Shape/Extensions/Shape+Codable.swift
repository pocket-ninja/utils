//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

extension Shape: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier, index, path, style
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commands = try container.decode([PathCommand].self, forKey: .path)
        identifier = try container.decode(Int.self, forKey: .identifier)
        index = try container.decode(Int.self, forKey: .index)
        style = try container.decode(ShapeStyle.self, forKey: .style)
        path = CGPath.with(commands: commands)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path.commands, forKey: .path)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(index, forKey: .index)
        try container.encode(style, forKey: .style)
    }
}
