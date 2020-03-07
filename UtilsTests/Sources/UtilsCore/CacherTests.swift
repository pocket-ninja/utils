//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
@testable import UtilsCore

class CacherTests: XCTestCase {

    var cacher: Cacher<String, Int>!
    var generationCount: Int = 0

    override func setUp() {
        super.setUp()

        cacher = Cacher { [weak self] item in
            self?.generationCount += 1
            return item.count
        }
    }

    override func tearDown() {
        cacher = nil
        generationCount = 0
        super.tearDown()
    }

    func testCacheValue() {
        XCTAssertEqual(cacher.cache(item: "_"), 1)
        XCTAssertEqual(cacher.cached(item: "_"), 1)
    }

    func testRemoveCacheValue() {
        cacher.cache(item: "_")
        cacher.removeCache(for: "_")
        XCTAssertNil(cacher.cached(item: "_"))
    }

    func testCacheMultipleTimes() {
        (0..<10).forEach { _ in cacher.cache(item: "_") }
        XCTAssertEqual(generationCount, 1)
    }

    func testUpdateCacheValue() {
        (0..<10).forEach { _ in cacher.cache(item: "_", update: true) }
        XCTAssertEqual(generationCount, 10)
    }
}
