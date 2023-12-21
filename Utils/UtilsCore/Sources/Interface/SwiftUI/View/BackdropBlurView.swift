//
//  Copyright © 2023 sroik. All rights reserved.
//

#if os(iOS)
import SwiftUI

public struct BackdropBlurView: View {
    public var radius: CGFloat
    public var opaque: Bool = true
    
    public var body: some View {
        UIBackdropView()
            .swiftUI()
            .blur(radius: radius, opaque: opaque)
    }
}
#endif
