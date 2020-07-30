//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

#if os(iOS)
public class LayerWrapperView<Layer: CALayer>: UIView {
    public typealias LayoutBlock = (LayerWrapperView) -> Void

    public let wrapped: Layer
    public var onLayout: LayoutBlock?
    public var fills: Bool
    public var centers: Bool

    public init(layer: Layer, fills: Bool = true, centers: Bool = true) {
        self.wrapped = layer
        self.fills = fills
        self.centers = centers
        super.init(frame: wrapped.frame)
        self.layer.addSublayer(wrapped)
        self.isUserInteractionEnabled = false
    }

    required convenience init?(coder _: NSCoder) {
        self.init(layer: Layer())
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if centers {
            wrapped.position = bounds.center
        }
        
        if fills {
            wrapped.frame = bounds
        }
        
        onLayout?(self)
    }
}
#endif
