//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGPoint {
    static prefix func - (l: CGPoint) -> CGPoint {
        return CGPoint(x: -l.x, y: -l.y)
    }

    static func - (l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint(x: l.x - r.x, y: l.y - r.y)
    }

    static func + (l: CGPoint, r: CGPoint) -> CGPoint {
        return CGPoint(x: l.x + r.x, y: l.y + r.y)
    }

    static func * (l: CGPoint, by: CGFloat) -> CGPoint {
        return CGPoint(x: l.x * by, y: l.y * by)
    }

    static func / (l: CGPoint, by: CGFloat) -> CGPoint {
        return CGPoint(x: l.x / by, y: l.y / by)
    }

    var abs: CGPoint {
        return CGPoint(x: Swift.abs(x), y: Swift.abs(y))
    }

    func distance(to: CGPoint) -> CGFloat {
        let dx = x - to.x
        let dy = y - to.y
        return hypot(dx, dy)
    }

    func rounded(rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> CGPoint {
        return CGPoint(x: x.rounded(rule), y: y.rounded(rule))
    }

    func translation(to point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x - self.x, y: point.y - self.y)
    }

    func translated(by offset: CGPoint) -> CGPoint {
        return CGPoint(x: x + offset.x, y: y + offset.y)
    }

    func related(in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: (x - rect.minX) / rect.width,
            y: (y - rect.minY) / rect.height
        )
    }

    func absolute(in rect: CGRect) -> CGPoint {
        return CGPoint(
            x: x * rect.width + rect.minX,
            y: y * rect.height + rect.minY
        )
    }

    func rotate(around point: CGPoint, by angle: CGFloat) -> CGPoint {
        let transform = CGAffineTransform(translationX: -point.x, y: -point.y)
            .rotated(by: angle)
            .translatedBy(x: point.x, y: point.y)
        return self.applying(transform)
    }
}

public extension CGFloat {
    static var layoutEpsilon: CGFloat {
        return 1e-2
    }

    func absolute(in rect: CGRect) -> CGFloat {
        return self * Swift.min(rect.width, rect.height)
    }

    func related(in rect: CGRect) -> CGFloat {
        return self / Swift.min(rect.width, rect.height)
    }
}

public extension CGSize {
    enum ScaleMode {
        case fill
        case fit
    }

    var isEmpty: Bool {
        return width < .ulpOfOne || height < .ulpOfOne
    }

    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }

    var ratio: CGFloat? {
        guard !isEmpty else {
            return nil
        }

        return width / height
    }
    
    var minSide: CGFloat {
        return min(width, height)
    }

    var maxSide: CGFloat {
        return max(width, height)
    }


    static func - (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width - r.width, height: l.height - r.height)
    }

    static func + (l: CGSize, r: CGSize) -> CGSize {
        return CGSize(width: l.width + r.width, height: l.height + r.height)
    }

    static func * (l: CGSize, by: CGFloat) -> CGSize {
        return CGSize(width: l.width * by, height: l.height * by)
    }

    static func / (l: CGSize, by: CGFloat) -> CGSize {
        return CGSize(width: l.width / by, height: l.height / by)
    }

    func rounded() -> CGSize {
        return CGSize(width: round(width), height: round(height))
    }

    func fitted(in size: CGSize) -> CGSize {
        return self * scale(toFit: size)
    }

    func filled(in size: CGSize) -> CGSize {
        return self * scale(toFill: size)
    }

    func scale(toFill size: CGSize) -> CGFloat {
        guard !isEmpty, !size.isEmpty else {
            return 1.0
        }

        let hRelation = size.width / width
        let vRelation = size.height / height
        let maxRelation = max(hRelation, vRelation)
        return maxRelation
    }

    func scale(toFit size: CGSize) -> CGFloat {
        guard !isEmpty, !size.isEmpty else {
            return 1.0
        }

        let hRelation = size.width / width
        let vRelation = size.height / height
        let minRelation = min(hRelation, vRelation)
        return minRelation
    }

    func rotationScale(to angle: CGFloat) -> CGFloat {
        let minSide = min(width, height)
        let maxSide = max(width, height)
        let rotationScale = (maxSide * abs(sin(angle)) + minSide * abs(cos(angle))) / minSide
        return rotationScale
    }

    func rotated(to angle: CGFloat, scaleMode mode: ScaleMode) -> CGSize {
        let rotationScale = self.rotationScale(to: angle)
        let scale = mode == .fit ? 1 / rotationScale : rotationScale
        return self * scale
    }
}

public extension CGRect {
    static func * (l: CGRect, by: CGFloat) -> CGRect {
        return CGRect(origin: l.origin * by, size: l.size * by)
    }

    var maxSide: CGFloat {
        return size.maxSide
    }

    var minSide: CGFloat {
        return size.minSide
    }
    
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    var vertices: [CGPoint] {
        return [
            CGPoint(x: minX, y: minY),
            CGPoint(x: minX, y: maxY),
            CGPoint(x: maxX, y: maxY),
            CGPoint(x: maxX, y: minY)
        ]
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(
            x: center.x - size.width / 2,
            y: center.y - size.height / 2,
            width: size.width,
            height: size.height
        )
    }

    init(size: CGSize) {
        self.init(origin: .zero, size: size)
    }

    func distance(to rect: CGRect) -> CGFloat {
        return zip(vertices, rect.vertices).reduce(0) { accumulator, next in
            accumulator + next.0.distance(to: next.1)
        }
    }

    func offsetted(by: CGPoint) -> CGRect {
        return offsetBy(dx: by.x, dy: by.y)
    }

    func filled(in rect: CGRect) -> CGRect {
        let scaledSize = size.filled(in: rect.size)
        return CGRect(origin: .zero, size: scaledSize).centered(in: rect)
    }

    func fitted(in rect: CGRect) -> CGRect {
        let scaledSize = size.fitted(in: rect.size)
        return CGRect(origin: .zero, size: scaledSize).centered(in: rect)
    }

    func centered(in rect: CGRect) -> CGRect {
        let width = (rect.width - self.width) / 2
        let height = (rect.height - self.height) / 2
        let translation = CGPoint(x: width, y: height)
        return CGRect(origin: rect.origin.translated(by: translation), size: size)
    }

    func transform(toBecome rect: CGRect) -> CGAffineTransform {
        guard !size.isEmpty, !rect.size.isEmpty else {
            return .identity
        }

        let translation = center.translation(to: rect.center)
        let scale = (x: rect.size.width / size.width, y: rect.size.height / size.height)

        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let scaleTransform = CGAffineTransform(scaleX: scale.x, y: scale.y)
        let finalTransform = scaleTransform.concatenating(translationTransform)
        return finalTransform
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(105_943)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(105_943)
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin)
        hasher.combine(size)
    }
}
