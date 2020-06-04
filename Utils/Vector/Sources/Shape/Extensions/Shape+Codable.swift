//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

extension Shape: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, path, style
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let commands = try container.decode([PathCommand].self, forKey: .path)
        id = try container.decode(Int.self, forKey: .id)
        style = try container.decode(ShapeStyle.self, forKey: .style)
        path = CGPath.with(commands: commands)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path.commands, forKey: .path)
        try container.encode(id, forKey: .id)
        try container.encode(style, forKey: .style)
    }
}
