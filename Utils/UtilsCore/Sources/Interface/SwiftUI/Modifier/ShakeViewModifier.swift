//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import SwiftUI
import UIKit

public extension Notification.Name {
    static let didShake = Notification.Name(rawValue: "device-did-shake-notification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .didShake, object: nil)
        }
         
        super.motionEnded(motion, with: event)
     }
}

public struct ShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .onAppear() // this has to be here because of a SwiftUI bug
            .onReceive(NotificationCenter.default.publisher(for: .didShake)) { _ in
                action()
            }
    }
}

public extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeViewModifier(action: action))
    }
}
#endif
