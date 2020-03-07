//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol Token {
    var isCancelled: Bool { get }
    func cancel()
}

public class SimpleToken: Token {
    public typealias Action = () -> Void

    public private(set) var isCancelled: Bool = false

    public init(action: @escaping Action = {}) {
        self.action = action
    }

    public func cancel() {
        synchronized(self) {
            if isCancelled {
                return
            }

            isCancelled = true
            action()
        }
    }

    private let action: Action
}

public class DeinitToken: SimpleToken {
    public convenience init(token: Token) {
        self.init {
            token.cancel()
        }
    }

    deinit {
        cancel()
    }
}

public class TaggedToken: DeinitToken {
    public let tag: AnyObject

    public init(tag: AnyObject, action: @escaping Action = {}) {
        self.tag = tag
        super.init(action: action)
    }
}

public class CompositeToken: SimpleToken {
    public override func cancel() {
        super.cancel()
        for token in tokens {
            token.cancel()
        }
    }

    public func addOrIgnore(_ token: () -> Token) {
        synchronized(self) {
            if !isCancelled {
                tokens.append(token())
            }
        }
    }

    public func add(_ token: Token) {
        synchronized(self) {
            if isCancelled {
                token.cancel()
                return
            }

            tokens.append(token)
        }
    }

    public static func += (lhs: CompositeToken, rhs: Token) {
        lhs.add(rhs)
    }

    private var tokens: [Token] = []
}
