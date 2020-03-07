//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func synchronizedReloadData() {
        reloadData()
        layoutIfNeeded()
    }
}
