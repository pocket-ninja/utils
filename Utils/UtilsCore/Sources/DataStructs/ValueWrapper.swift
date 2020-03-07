//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public final class ValueWrapper<Type> {
    public let value: Type
    
    public init(_ value: Type) {
        self.value = value
    }
}
