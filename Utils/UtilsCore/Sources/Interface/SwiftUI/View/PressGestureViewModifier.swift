//
//  Copyright © 2025 sroik. All rights reserved.
//

import SwiftUI

// Modifier to instantly recognize a press inside a scroll view
// Native buttons are pressed with a delay
public struct PressGestureViewModifier: ViewModifier {
    @Binding public var pressed: Bool
    public var allowedMovement: CGFloat = 10
    public var onTap: () -> Void
    
    public func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .gesture(
                    PressGestureRecognizerRepresentable(
                        pressed: $pressed,
                        allowedMovement: allowedMovement,
                        onTap: onTap
                    )
                )
        } else {
            content
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
}

public extension View {
    func pressGesture(
        pressed: Binding<Bool>,
        allowedMovement: CGFloat = 10,
        onTap: @escaping () -> Void
    ) -> some View {
        modifier(PressGestureViewModifier(
            pressed: pressed,
            allowedMovement: allowedMovement,
            onTap: onTap
        ))
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var pressed: Bool = false
    
    ScrollView(.horizontal) {
        Color.red
            .frame(width: 200, height: 200)
            .opacity(pressed ? 0.5 : 1)
            .animation(.default, value: pressed)
            .pressGesture(pressed: $pressed, onTap: {})
            .padding(20)
    }
    .border(.gray)
}
