//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DebugOverridable<Value> {
    #if DEBUG
    public var wrappedValue: Value
    #else
    public let wrappedValue: Value
    #endif
    
    public init(wrappedValue value: Value) {
        self.wrappedValue = value
    }
}
