//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit
import UtilsCore

public class GradientRenderer {
    public static func render(_ gradient: Gradient, in ctx: CGContext) {
        ctx.saveGState()
        defer { ctx.restoreGState() }

        guard let cgGradient = gradient.cgGradient else {
            assertionWrapperFailure("invalid gradient stops")
            return
        }

        ctx.prepareToRender(gradient)
        let contextBounds = ctx.boundingBoxOfPath
        ctx.clip()

        switch gradient.type {
        case let .linear(start, end):
            ctx.drawLinearGradient(
                cgGradient,
                start: gradient.units.userSpace(point: start, in: contextBounds),
                end: gradient.units.userSpace(point: end, in: contextBounds),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )

        case let .radial(center, focal, radius):
            ctx.drawRadialGradient(
                cgGradient,
                startCenter: gradient.units.userSpace(point: focal, in: contextBounds),
                startRadius: 0,
                endCenter: gradient.units.userSpace(point: center, in: contextBounds),
                endRadius: gradient.units.userSpace(radius: radius, in: contextBounds),
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )
        }
    }
}

public extension Gradient {
    var cgGradient: CGGradient? {
        return CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: stops.map { $0.color } as CFArray,
            locations: stops.map { $0.offset }
        )
    }
}

private extension CGContext {
    func prepareToRender(_ gradient: Gradient) {
        guard gradient.units == .boundingBox, case .radial = gradient.type else {
            return
        }

        let ratio = boundingBoxOfPath.size.ratio ?? 1.0
        let isLandscape = ratio > 1.0

        scaleBy(
            x: isLandscape ? 1 : ratio,
            y: isLandscape ? (1 / ratio) : 1
        )
    }
}
