//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public struct Matrix<T> {
    public let rows: Int
    public let columns: Int
    public private(set) var grid: [T]

    public var count: Int {
        return rows * columns
    }

    public init() {
        rows = 0
        columns = 0
        grid = [T]()
    }

    public init(rows: Int, columns: Int, repeating value: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: value, count: rows * columns)
    }

    public init?(rows: Int, columns: Int, grid: [T]) {
        guard grid.count == columns * rows else {
            return nil
        }

        self.rows = rows
        self.columns = columns
        self.grid = grid
    }

    public init?(array: [[T]]) {
        rows = array.count
        columns = array.first?.count ?? 0
        grid = [T]()

        for row in array {
            guard row.count == columns else {
                return nil
            }

            grid.append(contentsOf: row)
        }
    }

    public subscript(row: Int, column: Int) -> T {
        get {
            precondition(isValid(row: row, column: column))
            return grid[(row * columns) + column]
        }
        set {
            precondition(isValid(row: row, column: column))
            grid[(row * columns) + column] = newValue
        }
    }

    public subscript(row: Int) -> [T] {
        let start = row * columns
        let end = start + columns
        return Array(grid[start ..< end])
    }
}

public extension Matrix {
    typealias EnumerationBlock = (_ row: Int, _ column: Int, _ element: T) -> Void
    typealias Position = MatrixPosition

    subscript(position: Position) -> T {
        get {
            return self[position.row, position.column]
        }
        set {
            self[position.row, position.column] = newValue
        }
    }

    subscript(safe position: Position) -> T? {
        return self[safe: position.row, position.column]
    }

    subscript(safe row: Int, column: Int) -> T? {
        return grid[safe: (row * columns) + column]
    }

    subscript(row row: Int) -> [T] {
        return self[row]
    }

    subscript(safeRow row: Int) -> [T]? {
        return (0 ..< rows).contains(row) ? self[row] : nil
    }

    subscript(column column: Int) -> [T] {
        let end = count - (columns - column)
        return stride(from: column, through: end, by: columns).map { grid[$0] }
    }

    subscript(safeColumn column: Int) -> [T]? {
        return (0 ..< columns).contains(column) ? self[column: column] : nil
    }

    func array() -> [[T]] {
        return grid.chunks(columns)
    }

    func isValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    func isValid(position: Position) -> Bool {
        return isValid(row: position.row, column: position.column)
    }

    func enumerate(_ block: EnumerationBlock) {
        for r in 0 ..< rows {
            for c in 0 ..< columns {
                block(r, c, self[r, c])
            }
        }
    }

    func map<E>(_ transform: (T) throws -> E) rethrows -> Matrix<E> {
        return try Matrix<E>(rows: rows, columns: columns, grid: grid.map(transform))!
    }

    func forEach(_ body: (T) throws -> Void) rethrows {
        try grid.forEach(body)
    }

    mutating func transform(using block: (inout T) -> Void) {
        grid.transform(using: block)
    }

    func first(where predicate: (T) throws -> Bool) rethrows -> T? {
        return try grid.first(where: predicate)
    }
}

public struct MatrixPosition: Codable, Hashable {
    public var row: Int
    public var column: Int

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}

extension Matrix: Equatable where T: Equatable {}
extension Matrix: Hashable where T: Hashable {}
extension Matrix: Codable where T: Codable {}
