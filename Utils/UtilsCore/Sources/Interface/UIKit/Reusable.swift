//
//  Copyright © 2020 sroik. All rights reserved.
//

import Foundation

public protocol Reusable {
    static var reusableIdentifier: String { get }
}

public extension Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

#if os(iOS)
import UIKit
extension UICollectionReusableView: Reusable {}
#endif
