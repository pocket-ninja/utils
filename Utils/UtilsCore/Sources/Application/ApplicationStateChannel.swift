//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public enum ApplicationStateEvent: Equatable, CaseIterable {
    case willTerminate
    case didEnterBackground
    case willEnterForeground
    case didEnterForeground
    case didBecomeActive
    case willResignActive
}

public protocol ApplicationStateChannelType {
    var state: UIApplication.State { get }
    func subscribe(on queue: DispatchQueue?, with callback: @escaping (ApplicationStateEvent) -> Void) -> Token
    func setup()
}

public extension ApplicationStateChannelType {
    func subscribe(with callback: @escaping (ApplicationStateEvent) -> Void) -> Token {
        return subscribe(on: nil, with: callback)
    }

    func setup() {}
}

public final class ApplicationStateChannel: ApplicationStateChannelType {
    public static let shared = ApplicationStateChannel(application: .shared)

    public var state: UIApplication.State {
        return application.applicationState
    }

    public init(application: UIApplication) {
        self.application = application
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func setup() {
        ApplicationStateEvent.allCases.compactMap { $0.notificationName }.forEach {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification(_:)),
                name: $0,
                object: application
            )
        }
    }

    public func subscribe(on queue: DispatchQueue?,
                          with callback: @escaping (ApplicationStateEvent) -> Void) -> Token {
        return channel.subscribe(on: queue, with: callback)
    }

    @objc private func handleNotification(_ notification: Notification) {
        guard let event = ApplicationStateEvent(notificationName: notification.name) else {
            return
        }

        channel.send(event)

        if event == .willEnterForeground {
            justEnteredForeground = true
        }

        if event == .didBecomeActive, justEnteredForeground {
            channel.send(.didEnterForeground)
            justEnteredForeground = false
        }
    }

    private var justEnteredForeground: Bool = true
    private let application: UIApplication
    private let channel = Channel<ApplicationStateEvent>()
}

public extension ApplicationStateEvent {
    var notificationName: Notification.Name? {
        switch self {
        case .didEnterForeground: return nil
        case .willEnterForeground: return UIApplication.willEnterForegroundNotification
        case .didEnterBackground: return UIApplication.didEnterBackgroundNotification
        case .willTerminate: return UIApplication.willTerminateNotification
        case .didBecomeActive: return UIApplication.didBecomeActiveNotification
        case .willResignActive: return UIApplication.willResignActiveNotification
        }
    }

    init?(notificationName name: Notification.Name) {
        switch name {
        case UIApplication.didEnterBackgroundNotification:
            self = .didEnterBackground
        case UIApplication.willEnterForegroundNotification:
            self = .willEnterForeground
        case UIApplication.willTerminateNotification:
            self = .willTerminate
        case UIApplication.didBecomeActiveNotification:
            self = .didBecomeActive
        case UIApplication.willResignActiveNotification:
            self = .willResignActive
        default:
            return nil
        }
    }
}
