//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS) || os(tvOS)
import SwiftUI
import UIKit

public struct UIViewControllerContainer<Child: UIViewController>: UIViewControllerRepresentable, Withable {
    public typealias UpdateHandler = (Child) -> Void
    
    public var updates: UpdateHandler = {_ in}
    public let builder: () -> Child

    public init(_ builder: @escaping () -> Child) {
        self.builder = builder
    }

    public func onUpdates(do handler: @escaping UpdateHandler) -> Self {
        with { $0.updates = handler }
    }
    
    public func makeUIViewController(context: Context) -> Child {
        builder()
    }

    public func updateUIViewController(_ uiViewController: Child, context: Context) {
        updates(uiViewController)
    }
}

public protocol SwiftUIViewControllerConvertable {
    associatedtype Child: UIViewController
    func swiftUI() -> UIViewControllerContainer<Child>
}

public extension SwiftUIViewControllerConvertable where Self: UIViewController {
    func swiftUI() -> UIViewControllerContainer<Self> {
        UIViewControllerContainer { self }
    }
}

extension UIViewController: SwiftUIViewControllerConvertable {
    public typealias Child = UIViewController
}
#endif
