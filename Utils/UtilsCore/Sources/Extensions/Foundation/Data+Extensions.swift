//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined(separator: "")
    }

    init?(hex: String) {
        guard hex.count % 2 == 0 else {
            assertionWrapperFailure("corrupted hex string")
            return nil
        }

        let byteLiterals = (0 ..< hex.count / 2).map {
            hex.substring(from: $0 * 2, to: $0 * 2 + 1)
        }

        var data = Data()
        for byteLiteral in byteLiterals {
            guard let byte = UInt8(byteLiteral, radix: 16) else {
                assertionWrapperFailure("corrupted hex string")
                return nil
            }

            data.append(byte)
        }

        self = data
    }
}
