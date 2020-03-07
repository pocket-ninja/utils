//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public protocol Reusable {
    static var reusableIdentifier: String { get }
}

public extension Reusable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {}
