//
//  Copyright © 2023 sroik. All rights reserved.
//

import Foundation

public extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        ascending(by: keyPath)
    }

    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using comparator: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try sorted {
            try comparator($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }

    func descending<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath, using: >)
    }

    func ascending<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        sorted(by: keyPath, using: <)
    }

    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.max { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.min { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

public extension Array {
    mutating func transform(using block: (inout Iterator.Element) -> Void) {
        indices.forEach { idx in
            block(&self[idx])
        }
    }
}

extension Array where Element: Identifiable {
    mutating func updateOrAppend(_ item: Element) {
        let existingIndex = firstIndex { $0.id == item.id }
        if let index = existingIndex {
            self[index] = item
        } else {
            append(item)
        }
    }
}
