//
//  Copyright © 2025 sroik. All rights reserved.
//

#if os(iOS)

import SwiftUI

public struct PressableViewModifier: ViewModifier {
    public var pressedScale: CGFloat
    public var pressedOpacity: CGFloat
    public var pressAnimation: Animation
    public var allowedMovement: CGFloat = 10
    public var onTap: () -> Void
    
    @State private var pressed: Bool = false
    @State private var dragging: Bool = false
    
    public func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            animated(content: content)
                .gesture(
                    PressGestureRecognizerRepresentable(
                        pressed: $pressed,
                        allowedMovement: allowedMovement,
                        onTap: onTap
                    )
                )
        } else {
            animated(content: content)
                .onTapGesture {
                    onTap()
                }
                .onLongPressGesture(
                    minimumDuration: 1,
                    maximumDistance: allowedMovement,
                    perform: {},
                    onPressingChanged: {
                        pressed = $0
                    }
                )
        }
    }
    
    private func animated(content: Content) -> some View {
        content
            .scaleEffect(pressed ? pressedScale : 1)
            .opacity(pressed ? pressedOpacity : 1)
            .animation(pressAnimation, value: pressed)
    }
}

public extension View {
    func pressable(
        pressedScale: CGFloat = 0.975,
        pressedOpacity: CGFloat = 1.0,
        pressAnimation: Animation = .easeInOut(duration: 0.25),
        allowedMovement: CGFloat = 10,
        onTap: @escaping () -> Void
    ) -> some View {
        modifier(PressableViewModifier(
            pressedScale: pressedScale,
            pressedOpacity: pressedOpacity,
            pressAnimation: pressAnimation,
            allowedMovement: allowedMovement,
            onTap: onTap
        ))
    }
}

#Preview {
    Color.red
        .frame(width: 200, height: 200)
        .pressable(
            pressedScale: 0.95,
            pressedOpacity: 0.9,
            pressAnimation: .easeInOut(duration: 0.25),
            onTap: {}
        )
}

#endif
