//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS) || os(tvOS)
import SwiftUI
import UIKit

public struct UIViewContainer<Child: UIView>: UIViewRepresentable, Withable {
    public typealias UpdateHandler = (Child) -> Void
    
    public var updates: UpdateHandler = {_ in}
    public let builder: () -> Child

    public init(builder: @escaping () -> Child) {
        self.builder = builder
    }

    public func makeUIView(context: Context) -> Child {
        builder()
    }
    
    public func onUpdates(do handler: @escaping UpdateHandler) -> Self {
        with { $0.updates = handler }
    }

    public func updateUIView(_ view: Child, context: Context) {
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        updates(view)
    }
}

public protocol SwiftUIViewConvertable {
    associatedtype Child: UIView
    func swiftUI() -> UIViewContainer<Child>
}

public extension SwiftUIViewConvertable where Self: UIView {
    func swiftUI() -> UIViewContainer<Self> {
        UIViewContainer { self }
    }
}

extension UIView: SwiftUIViewConvertable {
    public typealias Child = UIView
}

#endif
