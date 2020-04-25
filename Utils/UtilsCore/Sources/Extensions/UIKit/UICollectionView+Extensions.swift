//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

public extension UICollectionView {
    typealias CellConfigurator<Cell: UICollectionViewCell> = (Cell, IndexPath) -> Void

    func synchronizedReloadData() {
        reloadData()
        layoutIfNeeded()
    }

    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: Cell.reusableIdentifier)
    }

    func registerHeader<View: UICollectionReusableView>(_ viewClass: View.Type) {
        register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: View.reusableIdentifier
        )
    }
    
    func registerFooter<View: UICollectionReusableView>(_ viewClass: View.Type) {
        register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: View.reusableIdentifier
        )
    }

    func configuredCell<Cell: UICollectionViewCell>(
        at indexPath: IndexPath,
        with configurator: CellConfigurator<Cell>
    ) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: Cell.reusableIdentifier, for: indexPath)

        (cell as? Cell).apply {
            configurator($0, indexPath)
        }

        return cell
    }

}
