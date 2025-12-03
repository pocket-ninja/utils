//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

extension ShapeFill: Codable {
    private enum CodingKeys: String, CodingKey {
        case base, color, gradient
    }

    private enum Base: String, Codable {
        case color, gradient
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .color:
            let colorString = try container.decode(String.self, forKey: .color)
            let color = try UIColor(string: colorString).get().cgColor
            self = .color(color)
        case .gradient:
            self = .gradient(try container.decode(Gradient.self, forKey: .gradient))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .color(cgColor):
            try container.encode(Base.color, forKey: .base)
            try container.encode(UIColor(cgColor: cgColor).rgbaString, forKey: .color)
        case let .gradient(gradient):
            try container.encode(Base.gradient, forKey: .base)
            try container.encode(gradient, forKey: .gradient)
        }
    }
}

extension ShapeStroke: Codable {
    private enum CodingKeys: String, CodingKey {
        case lineJoin, lineCap, lineWidth, color
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorString = try container.decode(String.self, forKey: .color)
        lineWidth = try container.decode(CGFloat.self, forKey: .lineWidth)
        lineCap = try container.decode(CGLineCap.self, forKey: .lineCap)
        lineJoin = try container.decode(CGLineJoin.self, forKey: .lineJoin)
        color = try UIColor(string: colorString).get().cgColor
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(UIColor(cgColor: color).rgbaString, forKey: .color)
        try container.encode(lineJoin, forKey: .lineJoin)
        try container.encode(lineWidth, forKey: .lineWidth)
        try container.encode(lineCap, forKey: .lineCap)
    }
}

extension CGLineJoin: @retroactive Codable {}
extension CGLineCap: @retroactive Codable {}
