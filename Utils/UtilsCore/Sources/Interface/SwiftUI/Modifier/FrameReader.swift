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
        key: Key.Type = FramePreferenceKey.self,
        reader: @escaping (CGRect) -> Void = {_ in}
    ) -> some View where Key.Value == CGRect {
        background(GeometryReader { proxy in
            Color.clear
                .preference(
                    key: key,
                    value: proxy.frame(in: space)
                )
        })
        .onPreferenceChange(key, perform: reader)
    }
    
    @inlinable
    func readFrame<Key: PreferenceKey>(space: CoordinateSpace = .local, to property: Binding<CGRect>) -> some View {
        observeFrame(space: space, key: FramePreferenceKey.self) { frame in
            property.wrappedValue = frame
        }
    }
    
    @inlinable
    func readSize(reader: @escaping (CGSize) -> Void) -> some View {
        observeFrame(space: .local, key: FramePreferenceKey.self) { frame in
            reader(frame.size)
        }
    }
    
    @inlinable
    func readSize(to property: Binding<CGSize>) -> some View {
        readSize { size in
            property.wrappedValue = size
        }
    }
}
