//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public typealias Session = UInt

public extension Session {
    var isFirst: Bool {
        return self == 1
    }
}

public protocol SessionCounterType {
    var versionAgnosticSession: Session { get }
    var versionSpecificSession: Session { get }
    func activate()
    func start()
}

public final class SessionCounter: SessionCounterType {
    public var versionAgnosticSession: Session {
        return versionAgnosticCounter.count
    }

    public var versionSpecificSession: Session {
        return versionSpecificCounter.count
    }

    public init(version: String, storage: Storage, domain: String) {
        versionAgnosticCounter = PersistentCounter(storage: storage, domain: domain)
        versionSpecificCounter = PersistentCounter(storage: storage, domain: "\(domain)_\(version)")
    }

    /**
     * Increases session count if it's started.
     * The best place for it is applicationWillEnterForeground method of appDelegate.
     */
    public func activate() {
        if isStarted {
            versionAgnosticCounter.increase()
            versionSpecificCounter.increase()
        }
    }

    /**
     * Starts manual session counting.
     * Calling this method will also call .activate() method.
     */
    public func start() {
        if isStarted {
            return
        }

        isStarted = true
        activate()
    }

    private var isStarted: Bool = false
    private let versionSpecificCounter: PersistentCounterProtocol
    private let versionAgnosticCounter: PersistentCounterProtocol
}

public extension SessionCounter {
    /* Don't change it across versions. Just let it live :) */
    private static let sharedDomain = "com.sroik.user_sessions"

    static let shared = SessionCounter(
        version: Target.current.version + "-" + Target.current.build,
        storage: UserDefaults.standard,
        domain: SessionCounter.sharedDomain
    )
}
