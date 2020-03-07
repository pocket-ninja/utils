//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public struct Queue<Item> {
    public typealias Comparator = (_ l: Item, _ r: Item) -> Bool

    public var comparator: Comparator? {
        didSet {
            sortIfNeeded()
        }
    }

    public var size: Int {
        return items.count
    }

    public var isEmpty: Bool {
        return items.isEmpty
    }

    public init(items: [Item] = [], comparator: Comparator? = nil) {
        self.comparator = comparator
        self.items = items
        sortIfNeeded()
    }

    public func peek() -> Item? {
        return items.first
    }

    public mutating func next() -> Item? {
        return items.isEmpty ? nil : items.remove(at: 0)
    }

    public mutating func append(_ item: Item) {
        append([item])
    }

    public mutating func append(_ items: [Item]) {
        self.items.append(contentsOf: items)
        sortIfNeeded()
    }

    public mutating func removeAll() {
        items.removeAll()
    }

    public mutating func sortIfNeeded() {
        guard let comparator = self.comparator else {
            return
        }

        items.sort(by: comparator)
    }

    public private(set) var items: [Item]
}
