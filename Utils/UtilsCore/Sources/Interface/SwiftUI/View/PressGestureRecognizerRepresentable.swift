//
//  Copyright © 2025 sroik. All rights reserved.
//

#if os(iOS)

import SwiftUI

public struct PressGestureRecognizerRepresentable: UIGestureRecognizerRepresentable {
    @Binding public  var pressed: Bool
    public var allowedMovement: CGFloat
    public var onTap: () -> Void
    
    @State private var startLocation: CGPoint = .zero
    
    public func makeUIGestureRecognizer(context: Context) -> UILongPressGestureRecognizer {
        let recognizer = UILongPressGestureRecognizer()
        recognizer.delegate = context.coordinator
        recognizer.cancelsTouchesInView = false
        recognizer.delaysTouchesBegan = false
        recognizer.minimumPressDuration = 0.0
        recognizer.allowableMovement = allowedMovement
        return recognizer
    }
    
    public func handleUIGestureRecognizerAction(_ recognizer: UILongPressGestureRecognizer, context: Context) {
        let location = recognizer.location(in: recognizer.view)
        
        switch recognizer.state {
        case .possible:
            return
        case .began:
            context.coordinator.startLocation = location
            pressed = true
        case .changed:
            let translation = location - context.coordinator.startLocation
            if abs(translation.x) > allowedMovement || abs(translation.y) > allowedMovement {
                recognizer.isEnabled = false
                recognizer.isEnabled = true
            }
        case .failed, .cancelled:
            pressed = false
        case .ended:
            pressed = false
            onTap()
        @unknown default:
            assertionWrapperFailure("unknown press gesture state: \(recognizer.state)")
        }
    }

    public func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        return Coordinator()
    }
    
    final public class Coordinator: NSObject, UIGestureRecognizerDelegate {
        public var startLocation: CGPoint = .zero
        
        public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        public func gestureRecognizer(
            _ first: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith second: UIGestureRecognizer
        ) -> Bool {
            return true
        }
    }
}

#endif
