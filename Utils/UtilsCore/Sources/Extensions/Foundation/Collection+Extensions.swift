//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Hashable {
    public func unique() -> [Element] {
        var seen: [Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

public extension Array {
    mutating func transform(using block: (inout Iterator.Element) -> Void) {
        indices.forEach { idx in
            block(&self[idx])
        }
    }

    func chunks(_ chunkSize: Int) -> [[Element]] {
        return chunks(chunkSize) { $0 }
    }

    func chunks<T>(
        _ chunkSize: Int,
        transform: ([Element]) throws -> T
    ) rethrows -> [T] {
        guard count % chunkSize == 0 else {
            assertionWrapperFailure("mod should be zero")
            return []
        }

        return try stride(from: 0, to: count, by: chunkSize).map {
            let subArray = Array(self[$0 ..< $0 + chunkSize])
            return try transform(subArray)
        }
    }
}
