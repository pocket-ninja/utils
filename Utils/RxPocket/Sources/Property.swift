//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

/// `Property` is a read-only wrapper for `BehaviorRelay`.
///
/// Unlike `BehaviorRelay` it can't accept values
public final class Property<Element>: ObservableType {
    public var value: Element {
        relay.value
    }

    public convenience init(value: Element) {
        self.init(relay: BehaviorRelay(value: value))
    }

    public convenience init(value: Element, then observable: Observable<Element>) {
        self.init(value: value)
        _ = observable.bind(to: relay)
    }

    public init(relay: BehaviorRelay<Element>) {
        self.relay = relay
    }

    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        relay.subscribe(observer)
    }

    public func asObservable() -> Observable<Element> {
        relay.asObservable()
    }

    public func map<T>(transform: @escaping (Element) -> T) -> Property<T> {
        let initial = transform(value)
        let observable = relay.skip(1).asObservable().map(transform)
        return Property<T>(value: initial, then: observable)
    }

    private let relay: BehaviorRelay<Element>
}

public extension BehaviorRelay {
    func asProperty() -> Property<Element> {
        Property(relay: self)
    }
}
