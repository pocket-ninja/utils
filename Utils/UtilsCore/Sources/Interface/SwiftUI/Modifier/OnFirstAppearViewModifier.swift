//
//  Copyright © 2023 sroik. All rights reserved.
//

import SwiftUI

public struct OnFirstAppearViewModifier: ViewModifier {
    @State private var isFirstAppear = false
    
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
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
