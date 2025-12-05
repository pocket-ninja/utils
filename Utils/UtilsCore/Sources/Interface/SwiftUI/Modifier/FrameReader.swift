//
//  Copyright © 2024 sroik. All rights reserved.
//

import SwiftUI

public struct FramePreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

public extension View {
    @inlinable
    func observeFrame<Key: PreferenceKey>(
        space: CoordinateSpace = .local,
        key: Key.Type = FramePreferenceKey.self
    ) -> some View where Key.Value == CGRect {
        background(GeometryReader { proxy in
            Color.clear
                .preference(
                    key: key,
                    value: proxy.frame(in: space)
                )
        })
    }
    
    @inlinable
    func readFrame<Key: PreferenceKey>(
        space: CoordinateSpace = .local,
        key: Key.Type = FramePreferenceKey.self,
        reader: @escaping (CGRect) -> Void
    ) -> some View where Key.Value == CGRect {
        observeFrame(space: space, key: key)
            .onPreferenceChange(key) { frame in
                reader(frame)
            }
    }
}
