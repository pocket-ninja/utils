//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit
import UniformTypeIdentifiers

public enum ShareImageCompression {
    case png
    case jpg(quality: CGFloat)
}

public struct ShareFile {
    var url: URL
    var type: UTType
}

public enum ShareItem {
    case image(UIImage, compression: ShareImageCompression)
    case data(Data, type: UTType)
    case text(String)
    case files([ShareFile])
}

public struct ShareContent {
    public var item: ShareItem
    public var caption: String?
    public var subject: String?
    
    public init(item: ShareItem, caption: String? = nil, subject: String? = nil) {
        self.item = item
        self.caption = caption
        self.subject = subject
    }
}

public extension ShareItem {
    static func file(url: URL, type: UTType) -> ShareItem {
        return ShareItem.files([ShareFile(url: url, type: type)])
    }
}

public extension ShareImageCompression {
    var ext: String {
        switch self {
        case .png: return "png"
        case .jpg: return "jpeg"
        }
    }
}

public extension UIImage {
    func data(compression: ShareImageCompression) -> Data? {
        switch compression {
        case .png:
            return pngData()
        case .jpg(let quality):
            return jpegData(compressionQuality: quality)
        }
    }
}
