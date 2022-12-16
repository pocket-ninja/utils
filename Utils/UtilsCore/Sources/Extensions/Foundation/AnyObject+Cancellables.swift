//
//  Copyright © 2022 sroik. All rights reserved.
//

import Combine
import Foundation

public protocol HasCancellables: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
}

private var cancellablesKey: String = "object_cancellables"

private final class CancellablesContainer: NSObject {
    var cancellables: Set<AnyCancellable> = []
}

public extension HasCancellables {
    var cancellables: Set<AnyCancellable> {
        get {
            synchronized(self) {
                if let result = objc_getAssociatedObject(self, &cancellablesKey) as? CancellablesContainer {
                    return result.cancellables
                }

                return []
            }
        }

        set {
            synchronized(self) {
                let container = CancellablesContainer()
                container.cancellables = newValue
                objc_setAssociatedObject(self, &cancellablesKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

public extension AnyCancellable {
    func store(in container: HasCancellables) {
        store(in: &container.cancellables)
    }
}
