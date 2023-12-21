//
//  Copyright © 2023 sroik. All rights reserved.
//

import SwiftUI

public struct OnFirstAppearViewModifier: ViewModifier {
    @State private var isFirstAppear = false
    
    public var action: () -> Void
    
    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !isFirstAppear {
                    isFirstAppear = true
                    action()
                }
            }
    }
    
}

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearViewModifier(action: action))
    }
}
