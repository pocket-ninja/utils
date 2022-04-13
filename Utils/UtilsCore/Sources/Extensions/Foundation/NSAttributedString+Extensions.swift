//
//  Copyright © 2020 sroik. All rights reserved.
//

#if os(iOS) || os(watchOS)
import UIKit

public extension NSAttributedString {
    static func with(
        text: String? = nil,
        font: UIFont? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment = .center,
        lineSpacing: CGFloat = 0,
        kerning: CGFloat = 0
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        paragraph.lineSpacing = lineSpacing

        var attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraph,
            .kern: kerning
        ]

        color.apply { attributes[.foregroundColor] = $0 }
        font.apply { attributes[.font] = $0 }

        return NSAttributedString(string: text ?? "", attributes: attributes)
    }

    var font: UIFont? {
        return appliedAttributes[.font] as? UIFont
    }

    var appliedAttributes: [NSAttributedString.Key: Any] {
        let range = NSRange(location: 0, length: length)
        let attrs = attributes(at: 0, longestEffectiveRange: nil, in: range)
        return attrs
    }

    var bounds: CGRect {
        let maxSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        return boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
    }

    func withFont(_ font: UIFont) -> NSAttributedString {
        var attrs = appliedAttributes
        attrs[.font] = font
        return NSAttributedString(string: string, attributes: attrs)
    }

    func fitted(in size: CGSize) -> NSAttributedString {
        guard let oldFont = self.font else {
            return self
        }

        let scale = bounds.size.scale(toFit: size)
        let font = oldFont.withSize(oldFont.pointSize * scale)
        return withFont(font)
    }

    func fontSize(toFit width: CGFloat) -> CGFloat {
        guard let font = self.font else {
            return 0
        }

        let lines = string.components(separatedBy: .whitespacesAndNewlines)
        let longest = lines.max { $1.count > $0.count }
        guard let longestLine = longest else {
            return 0
        }

        for fontSize in stride(from: Int(font.pointSize), to: 0, by: -1) {
            var attrs = appliedAttributes
            attrs[.font] = font.withSize(CGFloat(fontSize))

            let longestLineAttrString = NSAttributedString(string: longestLine, attributes: attrs)
            let longestLineWidth = longestLineAttrString.bounds.width
            if longestLineWidth <= width {
                return CGFloat(fontSize)
            }
        }

        return 0
    }

    func fitting(width: CGFloat) -> NSAttributedString {
        guard let oldFont = self.font else {
            return self
        }

        let reducedFontSize = fontSize(toFit: width)
        let font = oldFont.withSize(reducedFontSize)
        return withFont(font)
    }
}
#endif
