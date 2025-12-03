//
//  Copyright © 2025 sroik. All rights reserved.
//

import SwiftUI

public struct PressGesture: ViewModifier {
    @Binding public var pressed: Bool
    public var maximumDistance: CGSize
    public var onRelease: (Bool) -> Void
    
    @State private var dragging: Bool = false
    
    public func body(content: Content) -> some View {
        // The `simultaneousGesture` doesn't work in iOS 17
        // and earlier it blocks parent ScrollView
        if #available(iOS 18.0, macOS 15.0, watchOS 11.0, *) {
            dragPressing(content: content)
        } else {
            longPressing(content: content)
        }
    }
    
    private func longPressing(content: Content) -> some View {
        content
            .onTapGesture {
                onRelease(true)
            }
            .onLongPressGesture(
                minimumDuration: 1,
                maximumDistance: 10,
                perform: {},
                onPressingChanged: {
                    pressed = $0
                }
            )
    }
    
    private func dragPressing(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(
                    minimumDistance: 0,
                    coordinateSpace: .global
                )
                .onChanged { value in
                    if !dragging {
                        dragging = true
                        pressed = true
                    }
                
                    /* the press doesn't count if the user moves finger too far */
                    if abs(value.translation.width) > maximumDistance.width ||
                        abs(value.translation.height) > maximumDistance.height {
                        pressed = false
                    }
                }
                .onEnded { value in
                    onRelease(pressed)
                    pressed = false
                    dragging = false
                }
            )
    }
}

public extension View {
    func pressGesture(
        pressed: Binding<Bool>,
        maximumDistance: CGSize = .init(width: 10, height: 10),
        onRelease: @escaping (Bool) -> Void = {_ in},
        onTap: @escaping () -> Void = {}
    ) -> some View {
        modifier(PressGesture(
            pressed: pressed,
            maximumDistance: maximumDistance,
            onRelease: { pressed in
                onRelease(pressed)
                
                if pressed {
                    onTap()
                }
            }
        ))
    }
}
