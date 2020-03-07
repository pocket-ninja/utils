//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UIColor {
    typealias RGBATuple = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    typealias HSBATuple = (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)

    var image: UIImage {
        return image(size: CGSize(width: 1, height: 1))
    }

    var brightness: CGFloat {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        let brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000
        return brightness
    }

    var isLight: Bool {
        return brightness > 0.5
    }

    var rgba: RGBATuple {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }

    var hsba: HSBATuple {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }

    var hexString: String {
        let (r, g, b, a) = rgba
        if a < 1.0 {
            return String(
                format: "%02X%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255),
                Int(a * 255)
            )
        } else {
            return String(
                format: "%02X%02X%02X",
                Int(r * 255),
                Int(g * 255),
                Int(b * 255)
            )
        }
    }

    var rgbaString: String {
        let (r, g, b, a) = rgba
        return "\(r) \(g) \(b) \(a)"
    }

    convenience init?(string: String, separator: String = " ") {
        let strComponents = string.components(separatedBy: separator).map { $0.trimmingCharacters(in: .whitespaces) }
        let components = strComponents.compactMap(Double.init)

        guard
            [3, 4].contains(components.count),
            components.allSatisfy({ (0 ... 1) ~= $0 }),
            components.count == strComponents.count
        else {
            return nil
        }

        self.init(
            red: CGFloat(components[0]),
            green: CGFloat(components[1]),
            blue: CGFloat(components[2]),
            alpha: CGFloat(components[safe: 3] ?? 1)
        )
    }

    convenience init?(hex: String) {
        var string: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if string.hasPrefix("#") {
            string.remove(at: string.startIndex)
        }

        let divisor: CGFloat = 255
        var value: UInt32 = 0
        Scanner(string: string).scanHexInt32(&value)

        switch string.count {
        case 6:
            self.init(
                red: CGFloat((value & 0xFF0000) >> 16) / divisor,
                green: CGFloat((value & 0x00FF00) >> 8) / divisor,
                blue: CGFloat(value & 0x0000FF) / divisor,
                alpha: 1.0
            )
        case 8:
            self.init(
                red: CGFloat((value & 0xFF00_0000) >> 24) / divisor,
                green: CGFloat((value & 0x00FF_0000) >> 16) / divisor,
                blue: CGFloat((value & 0x0000_FF00) >> 8) / divisor,
                alpha: CGFloat(value & 0x0000_00FF) / divisor
            )
        default:
            assertionWrapperFailure("incorrect hex format")
            return nil
        }
    }

    func image(size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        return image(
            size: size,
            roundedCorners: .allCorners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
    }

    func image(
        size: CGSize,
        roundedCorners: UIRectCorner,
        cornerRadii: CGSize
    ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: roundedCorners, cornerRadii: cornerRadii)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.clear(rect)
            ctx.setFillColor(cgColor)
            path.fill()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        return image
    }

    func isEqual(to color: UIColor?, withThreshold threshold: Double = .ulpOfOne) -> Bool {
        guard let color = color else {
            return false
        }

        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        let distance = sqrt((r1 - r2) ** 2 + (g1 - g2) ** 2 + (b1 - b2) ** 2 + (a1 - a2) ** 2)
        /* It's because of √(1^2 + 1^2 + 1^2 + 1^2) */
        let maxPossibleDistance = 2.0
        let allowedDistance = maxPossibleDistance * threshold
        let isEqual = Double(distance) < allowedDistance
        return isEqual
    }

    func mixed(with color: UIColor, proportion: Percent) -> UIColor {
        let (sr, sg, sb, sa) = rgba
        let (cr, cg, cb, ca) = color.rgba
        let sp = CGFloat(proportion.value)
        let cp = 1.0 - sp
        return UIColor(
            red: sr * sp + cr * cp,
            green: sg * sp + cg * cp,
            blue: sb * sp + cb * cp,
            alpha: sa * sp + ca * cp
        )
    }

    func lightened(intensity: Percent) -> UIColor {
        return mixed(with: .white, proportion: intensity)
    }

    func darkened(intensity: Percent) -> UIColor {
        return mixed(with: .black, proportion: intensity)
    }
}
