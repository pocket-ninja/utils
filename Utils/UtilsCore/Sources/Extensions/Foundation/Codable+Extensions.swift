//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public extension Encodable {
    func maybeEncoded() -> Data? {
        return try? encoded()
    }

    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

public extension Data {
    func maybeDecoded<T: Decodable>() -> T? {
        return try? decoded()
    }

    func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
}
