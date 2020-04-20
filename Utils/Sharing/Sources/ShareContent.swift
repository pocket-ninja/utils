//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import UIKit

public enum ShareItem {
    case image(UIImage)
    case file(URL)
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
    var value: Any {
        switch self {
        case let .image(image):
            return image
        case let .file(url):
            return url
        }
    }
}
