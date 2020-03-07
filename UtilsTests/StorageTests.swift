//
//  Copyright © 2020 sroik. All rights reserved.
//

import XCTest
import UtilsCore

class StorageTests: XCTestCase {
    func testSavesUUID() {
        let uuid = UUID()
        let storage = StorageMock()

        storage.set(uuid, forKey: "test_key")

        XCTAssertEqual(storage.values["test_key"] as? String, uuid.uuidString)
    }

    func testLoadsUUID() {
        let uuid = UUID()
        let storage = StorageMock()

        storage.set(uuid, forKey: "test_key")

        XCTAssertEqual(storage.uuid(forKey: "test_key"), uuid)
    }
}
