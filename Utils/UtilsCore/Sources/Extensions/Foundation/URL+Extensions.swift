//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Foundation

public extension URL {
    static func storeRate(appId: String) -> URL? {
        return URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)")
    }

    static func store(appId: String, provider: String, campaign: String) -> URL? {
        return URL(string: "https://apps.apple.com/app/apple-store/id\(appId)?pt=\(provider)&ct=\(campaign)&mt=8")
    }
    
    static func instagramApp(id: String) -> URL? {
        return URL(string: "instagram://user?username=\(id)")
    }
    
    static func instagramWeb(id: String) -> URL? {
        return URL(string: "https://www.instagram.com/\(id)")
    }
}
