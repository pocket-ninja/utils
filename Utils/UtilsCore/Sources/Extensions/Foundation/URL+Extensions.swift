//
//  Copyright © 2026 sroik. All rights reserved.
//

import Foundation

public extension URL {
    @available(iOS 16.0, *)
    static func appStoreReview(id: String) -> URL? {
        appStore(id: id)?.appending(queryItems: [
            .init(name: "action", value: "write-review")
        ])
    }
    
    @available(iOS 16.0, *)
    static func appStore(id: String, provider: String, campaign: String) -> URL? {
        appStore(id: id)?.appending(queryItems: [
            .init(name: "pt", value: provider),
            .init(name: "ct", value: campaign),
            .init(name: "mt", value: "8")
        ])
    }
    
    static func appStore(id: String) -> URL? {
        URL(string: "https://apps.apple.com/app/id\(id)")
    }
    
    static func instagramApp(id: String) -> URL? {
        URL(string: "instagram://user?username=\(id)")
    }
    
    static func instagramWeb(id: String) -> URL? {
        URL(string: "https://www.instagram.com/\(id)")
    }
}
