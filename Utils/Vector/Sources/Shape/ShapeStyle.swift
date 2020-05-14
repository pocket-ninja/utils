//
// Copyright (c) 2020 sroik. All rights reserved.
//

import CoreGraphics

public enum ShapeFill: Hashable {
    case color(CGColor)
    case gradient(Gradient)
}

public struct ShapeStroke: Hashable {
    public var lineJoin: CGLineJoin
    public var lineCap: CGLineCap
    public var lineWidth: CGFloat
    public var color: CGColor

    public init(
        lineJoin: CGLineJoin,
        lineCap: CGLineCap,
        lineWidth: CGFloat,
        color: CGColor
    ) {
        self.lineJoin = lineJoin
        self.lineCap = lineCap
        self.lineWidth = lineWidth
        self.color = color
    }
}

public struct ShapeStyle: Hashable, Codable {
    public var fill: ShapeFill
    public var stroke: ShapeStroke

    public init(fill: ShapeFill, stroke: ShapeStroke) {
        self.fill = fill
        self.stroke = stroke
    }
}
