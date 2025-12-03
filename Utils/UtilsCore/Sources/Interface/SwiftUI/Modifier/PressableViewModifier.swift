//
//  Copyright © 2025 sroik. All rights reserved.
//

import SwiftUI

public struct PressableViewModifier: ViewModifier {
    @State private var pressed = false
    
    var maximumDistance: CGSize
    var pressedScale: CGFloat
    var pressedOpacity: CGFloat
    var onTap: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? pressedScale : 1)
            .opacity(pressed ? pressedOpacity : 1)
            .animation(.easeInOut(duration: 0.15), value: pressed)
            .pressGesture(pressed: $pressed, maximumDistance: maximumDistance, onTap: onTap)
    }
}

public extension View {
    func pressable(
        maximumDistance: CGSize = CGSize(width: 10, height: 10),
        pressedScale: CGFloat = 0.975,
        pressedOpacity: CGFloat = 1.0,
        onTap: @escaping () -> Void
    ) -> some View {
        modifier(PressableViewModifier(
            maximumDistance: maximumDistance,
            pressedScale: pressedScale,
            pressedOpacity: pressedOpacity,
            onTap: onTap
        ))
    }
}

#Preview {
    Color.red
        .frame(width: 100, height: 100)
        .pressable(
            maximumDistance: .init(width: 100, height: 10),
            pressedScale: 0.975,
            pressedOpacity: 0.75,
            onTap: {}
        )
}
