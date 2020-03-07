//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public enum OptionalTypeError: Error {
    case unexpectedNil
}

public extension Optional {
    func get() throws -> Wrapped {
        return try self.or(throw: OptionalTypeError.unexpectedNil)
    }

    /** If it's not nil, returns the unwrapped value. Otherwise throws `exception' */
    func or(throw exception: Error) throws -> Wrapped {
        switch self {
        case let .some(unwrapped): return unwrapped
        case .none: throw exception
        }
    }

    func apply(_ transform: (Wrapped) throws -> Void) rethrows {
        guard case let .some(value) = self else {
            return
        }

        try transform(value)
    }
}
