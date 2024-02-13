//
//  Copyright © 2023 sroik. All rights reserved.
//

import SwiftUI

public struct ScrollViewState: Equatable {
    var size: CGSize = .zero
    var contentSize: CGSize = .zero
    var contentOffset: CGPoint = .zero
}

public struct ScrollFramePreferenceKey: PreferenceKey {
    public static var defaultValue: CGRect = .zero
    public static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}

public extension CoordinateSpace {
    static let scrollFrameReaderName = "scroll-frame-reader"
    static let scrollFrameReader = CoordinateSpace.named(scrollFrameReaderName)
}

public struct ScrollViewStateReader: ViewModifier {
    public typealias Reader = (_ old: ScrollViewState, _ new: ScrollViewState) -> Void
    
    @State private var state: ScrollViewState
    
    public var reader: Reader
    
    public init(reader: @escaping Reader = {_,_ in}) {
        self.reader = reader
        self.state = .init()
    }
    
    public func body(content: Content) -> some View {
        content
            .readSize { size in
                let oldState = state
                state.size = size
                reader(oldState, state)
            }
            .readScrollFrame { frame in
                let oldState = state
                state.contentSize = frame.size
                state.contentOffset = frame.origin
                reader(oldState, state)
            }
    }
}

public extension View {
    @inlinable
    func observeScrollFrame() -> some View {
        observeFrame(
            space: .scrollFrameReader,
            key: ScrollFramePreferenceKey.self
        )
    }

    @inlinable
    func readScrollFrame(reader: @escaping (CGRect) -> Void) -> some View {
        self.coordinateSpace(name: CoordinateSpace.scrollFrameReaderName)
            .onPreferenceChange(ScrollFramePreferenceKey.self, perform: reader)
    }
    
    @inlinable
    func readScrollState(reader: @escaping ScrollViewStateReader.Reader) -> some View {
        modifier(ScrollViewStateReader(reader: reader))
    }
}

public extension ScrollViewState {
    var contentEndOffset: CGPoint {
        CGPoint(
            x: contentSize.width - size.width + contentOffset.x,
            y: contentSize.height - size.height + contentOffset.y
        )
    }
}
