//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import UIKit

#if os(iOS)
public extension CGContext {
    static func with(data: UnsafeMutableRawPointer? = nil, size: CGSize) -> CGContext? {
        return with(data: data, size: Size(cgSize: size))
    }

    /*
     * if `data' is nil, than the data for context is allocated automatically
     * and freed when the context is deallocated
     */
    static func with(data: UnsafeMutableRawPointer? = nil, size: Size<Int>) -> CGContext? {
        guard let ctx = CGContext(data: data,
                                  width: size.width,
                                  height: size.height,
                                  bitsPerComponent: BitmapPixel.bitsPerComponent,
                                  bytesPerRow: BitmapPixel.bytesPerPixel * size.width,
                                  space: BitmapPixel.colorSpace,
                                  bitmapInfo: BitmapPixel.bitmapInfo) else {
            assertionWrapperFailure("corrupted parameters")
            return nil
        }

        return ctx
    }

    var size: Size<Int> {
        return Size(width: width, height: height)
    }

    var scale: CGFloat {
        return ctm.scale.x / UIScreen.main.scale
    }

    func fill(_ rect: CGRect, with color: CGColor) {
        setFillColor(color)
        fill(rect)
    }

    func scale(by scale: CGFloat) {
        scaleBy(x: scale, y: scale)
    }

    func fill(with background: BitmapBackground) {
        switch background {
        case let .image(image): image.apply(fill(with:))
        case let .color(color): color.apply(fill(with:))
        case .clear: break
        }
    }

    func fill(with color: CGColor) {
        fill(CGRect(origin: .zero, size: size.cgSize), with: color)
    }

    func fill(with image: CGImage) {
        let bounds = CGRect(origin: .zero, size: size.cgSize)
        let imageSize = CGSize(width: image.width, height: image.height)
        let imageRect = CGRect(size: imageSize).filled(in: bounds)
        draw(image, in: imageRect)
    }

    func prepareForDrawing() {
        translateBy(x: 0, y: CGFloat(height))
        scaleBy(x: 1, y: -1)
        textMatrix = CGAffineTransform(scaleX: 1, y: -1)
    }

    func draw(_ attributedText: NSAttributedString, in rect: CGRect) {
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRangeMake(0, 0),
            nil,
            CGSize(width: .max, height: .max),
            nil
        )

        let offset = attributedText.font?.capHeight ?? 0
        let sizesDiff = suggestedSize - rect.size
        let textRect = CGRect(
            x: rect.origin.x - sizesDiff.width / 2,
            y: rect.origin.y - sizesDiff.height / 2 + offset,
            width: suggestedSize.width,
            height: suggestedSize.height
        )

        let ctFrame = CTFramesetterCreateFrame(
            framesetter,
            CFRangeMake(0, attributedText.length),
            CGPath(rect: textRect, transform: nil),
            nil
        )

        CTFrameDraw(ctFrame, self)
    }
}
#endif

public enum BitmapBackground {
    case image(CGImage?)
    case color(CGColor?)
    case clear
}

public struct BitmapPixel: Hashable {
    public var a: UInt8
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8
}

public extension BitmapPixel {
    static var bitsPerComponent: Int {
        return 8
    }

    static var bitsPerPixel: Int {
        return bitsPerComponent * 4
    }

    static var bytesPerPixel: Int {
        return bitsPerPixel / 8
    }

    static var alphaInfo: UInt32 {
        return CGImageAlphaInfo.premultipliedFirst.rawValue
    }

    static var bitmapInfo: UInt32 {
        return CGBitmapInfo.byteOrder32Big.rawValue | alphaInfo
    }

    static var colorSpace: CGColorSpace {
        return CGColorSpaceCreateDeviceRGB()
    }
}
