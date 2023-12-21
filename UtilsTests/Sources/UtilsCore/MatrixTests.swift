//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UtilsCore

class MatrixTests: XCTestCase {
    func testInitialization() {
        let m = Matrix<Int>(rows: 2, columns: 3, repeating: 5)
        XCTAssertEqual(m.grid, [5, 5, 5, 5, 5, 5])
    }

    func testIsValidRowAndColumn() {
        let m = Matrix<Double>(rows: 3, columns: 3, repeating: 0)
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                XCTAssertTrue(m.isValid(row: i, column: j))
            }
        }

        XCTAssertFalse(m.isValid(row: 0, column: 3))
        XCTAssertFalse(m.isValid(row: 3, column: 0))
    }

    func testIsValidPosition() {
        let m = Matrix<Double>(rows: 3, columns: 3, repeating: 0)
        XCTAssertTrue(m.isValid(position: MatrixPosition(row: 0, column: 0)))
        XCTAssertFalse(m.isValid(position: MatrixPosition(row: 0, column: 3)))
        XCTAssertFalse(m.isValid(position: MatrixPosition(row: 3, column: 0)))
    }

    func testWrongFormatInitialization() {
        XCTAssertNil(Matrix<Double>(array: [[1, 2, 3], [4, 5, 6], [7, 8]]))
        XCTAssertNil(Matrix<Double>(rows: 2, columns: 1, grid: [1, 2, 3]))
    }

    func testMatrixComparing() {
        let m = Matrix<Int>(rows: 2, columns: 2, repeating: 5)
        let m2 = Matrix<Int>(rows: 4, columns: 1, repeating: 5)
        XCTAssertTrue(m != m2)
        XCTAssertTrue(m == Matrix(array: [[5, 5], [5, 5]])!)
    }

    func testToArray() throws {
        let c = [[1, 2], [3, 4]]
        let m = try Matrix(array: c).get()
        XCTAssertTrue(m.array() == c)
    }

    func testSubscript() {
        var m = Matrix<Int>(array: [[1, 2], [3, 4]])!
        XCTAssertEqual(m[0, 0], 1)
        XCTAssertEqual(m[0][0], 1)
        XCTAssertEqual(m[0, 1], 2)
        XCTAssertEqual(m[0][1], 2)
        XCTAssertNil(m[safe: 2, 2])

        m[0, 0] = 10
        XCTAssertEqual(m[0, 0], 10)

        let position = MatrixPosition(row: 0, column: 0)
        m[position] = 11
        XCTAssertEqual(m[position], 11)
        XCTAssertNil(m[safe: MatrixPosition(row: -1, column: -1)])
    }

    func testEnumeration() {
        let m = Matrix<Int>(array: [[0, 1, 2, 3, 4]])!
        m.enumerate { row, column, element in
            XCTAssertEqual(row, 0)
            XCTAssertEqual(column, element)
        }
    }

    func testMap() {
        let m = Matrix<Int>(array: [[1, 2], [3, 4]])!
        let mapped = m.map { $0 * 10 }
        XCTAssert(mapped == Matrix<Int>(array: [[10, 20], [30, 40]])!)
    }

    func testTransform() {
        var m = Matrix<Int>(array: [[1, 2], [3, 4]])!
        m.transform { $0 *= 2 }
        XCTAssertTrue(m == Matrix<Int>(array: [[2, 4], [6, 8]])!)
    }

    func testPredicate() {
        let m = Matrix<Int>(array: [[1, 4], [9, 16]])!
        let e: Int? = m.first { sqrt(Double($0)) == 3 }
        XCTAssertEqual(e!, 9)
    }

    func testForEach() {
        var sum = 0
        let m = Matrix<Int>(array: [[1, 2], [3, 4]])!
        m.forEach { e in
            sum += e
        }
        XCTAssertEqual(sum, 1 + 2 + 3 + 4)
    }

    func testSubscriptRow() {
        let array = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 1, 1]]
        let m = Matrix<Int>(array: array)!
        array.indices.forEach { idx in
            XCTAssertEqual(array[idx], m[idx])
            XCTAssertEqual(array[idx], m[row: idx])
            XCTAssertNotNil(m[safeRow: idx])
        }

        XCTAssertNil(m[safeRow: 4])
        XCTAssertNil(m[safeRow: -1])
    }

    func testSubscriptColumn() throws {
        let array = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 1, 1]]
        let m = try Matrix<Int>(array: array).get()

        XCTAssertEqual(m[column: 1], [2, 5, 8, 1])
        XCTAssertEqual(m[column: 2], [3, 6, 9, 1])
        XCTAssertNotNil(m[column: 1])
        XCTAssertNotNil(m[column: 2])

        XCTAssertNil(m[safeColumn: 4])
        XCTAssertNil(m[safeColumn: -1])
    }
    
    func testGridArray() throws {
        let array = [[1, 2, 3], [4, 5, 6]]
        let m = try Matrix<Int>(array: array).get()
        XCTAssertEqual(m.array(), array)
    }
}
