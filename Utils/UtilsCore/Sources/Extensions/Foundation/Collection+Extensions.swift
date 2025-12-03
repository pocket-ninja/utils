//
//  Copyright © 2023 sroik. All rights reserved.
//

import Foundation

public extension Sequence {
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using comparator: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try sorted {
            try comparator($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        sorted(by: keyPath) { l, r in
            ascending ? l < r : l > r
        }
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
    
    func list() -> [Element] {
        Array(self)
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

public extension Array where Element: Identifiable {
    mutating func updateOrAppend(_ item: Element) {
        let existingIndex = firstIndex { $0.id == item.id }
        if let index = existingIndex {
            self[index] = item
        } else {
            append(item)
        }
    }
}
