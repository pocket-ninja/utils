//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import SwiftUI

public struct BackdropBlurView: View {
    public var radius: CGFloat
    public var opaque: Bool = true
    
    public init(radius: CGFloat = 20, opaque: Bool = true) {
        self.radius = radius
        self.opaque = opaque
    }
    
    public var body: some View {
        UIBackdropView()
            .swiftUI()
            .blur(radius: radius, opaque: opaque)
    }
}
#endif
