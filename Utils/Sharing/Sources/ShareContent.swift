//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit
import UniformTypeIdentifiers

public enum ShareImageCompression {
    case png
    case jpg(quality: CGFloat)
}

public enum ShareItem {
    case image(UIImage, compression: ShareImageCompression)
    case data(Data, type: UTType)
    case file(URL)
    case files([URL])
    case text(String)
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

public extension ShareImageCompression {
    var ext: String {
        switch self {
        case .png:
            return "png"
        case .jpg:
            return "jpeg"
        }
    }
}

public extension ShareItem {
    var activityValues: [Any] {
        switch self {
        case let .image(image, compression):
            return [image.data(compression: compression) ?? image]
        case let .data(data, _):
            return [data]
        case let .file(url):
            return [url]
        case let .files(urls):
            return urls
        case let .text(text):
            return [text]
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
