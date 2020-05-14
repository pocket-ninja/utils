//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

extension GradientType: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, start, end, center, focal, radius
    }

    private enum Base: String, Codable {
        case linear, radial
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .linear:
            self = .linear(
                start: try container.decode(CGPoint.self, forKey: .start),
                end: try container.decode(CGPoint.self, forKey: .end)
            )
        case .radial:
            self = .radial(
                center: try container.decode(CGPoint.self, forKey: .center),
                focal: try container.decode(CGPoint.self, forKey: .focal),
                radius: try container.decode(CGFloat.self, forKey: .radius)
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .linear(start, end):
            try container.encode(Base.linear, forKey: .base)
            try container.encode(start, forKey: .start)
            try container.encode(end, forKey: .end)

        case let .radial(center, focal, radius):
            try container.encode(Base.radial, forKey: .base)
            try container.encode(center, forKey: .center)
            try container.encode(focal, forKey: .focal)
            try container.encode(radius, forKey: .radius)
        }
    }
}

extension GradientStop: Codable {
    private enum CodingKeys: String, CodingKey {
        case offset, color
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorString = try container.decode(String.self, forKey: .color)
        offset = try container.decode(CGFloat.self, forKey: .offset)
        color = try UIColor(string: colorString).get().cgColor
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(offset, forKey: .offset)
        try container.encode(UIColor(cgColor: color).rgbaString, forKey: .color)
    }
}
