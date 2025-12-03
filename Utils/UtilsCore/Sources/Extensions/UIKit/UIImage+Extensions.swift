//
//  Copyright © 2025 sroik. All rights reserved.
//

import UIKit

extension UIImage {
    func decompressed() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var orientationTransform: CGAffineTransform {
        switch imageOrientation {
        case .left, .leftMirrored:
            return CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
                .translatedBy(x: 0, y: -size.height)
        case .right, .rightMirrored:
            return CGAffineTransform(rotationAngle: -CGFloat.pi * 0.5)
                .translatedBy(x: -size.width, y: 0)
        case .down, .downMirrored:
            return CGAffineTransform(rotationAngle: -CGFloat.pi)
                .translatedBy(x: -size.width, y: -size.height)
        case .up, .upMirrored:
            return .identity
        @unknown default:
            return .identity
        }
    }

    func cropped(to rect: CGRect) -> UIImage {
        let orientedRect = rect.applying(orientationTransform)
        let scaledRect = orientedRect * scale
        
        guard
            let cgImage = self.cgImage,
            let cropped = cgImage.cropping(to: scaledRect)
        else {
            return self
        }
        
        return UIImage(
            cgImage: cropped,
            scale: scale,
            orientation: imageOrientation
        )
    }

    func scaled(toFit side: CGFloat) -> UIImage {
        scaled(toFit: CGSize(width: side, height: side))
    }
    
    func scaled(toFit sizeToFit: CGSize) -> UIImage {
        let scale = (size * scale).scale(toFit: sizeToFit)
        return scaled(by: scale)
    }
    
    func scaled(by: CGFloat) -> UIImage {
        let size = (size * by).rounded()
        let bounds = CGRect(origin: .zero, size: size)
        let format = UIGraphicsImageRendererFormat.preferred()
        format.scale = scale
            
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
        let scaledImage = renderer.image { _ in
            draw(in: bounds)
        }
            
        return scaledImage
    }

    func cropCenter(withRatio ratio: CGFloat) -> UIImage {
        var cropSize = CGSize(width: size.width, height: size.width / ratio)
        
        /* fit crop size if it's filled */
        if cropSize.height > size.height {
            cropSize = cropSize * (size.height / cropSize.height)
        }
        
        let cropRect = CGRect(
            x: (size.width - cropSize.width) * 0.5,
            y: (size.height - cropSize.height) * 0.5,
            width: cropSize.width,
            height: cropSize.height
        )
        
        return cropped(to: cropRect)
    }
}
