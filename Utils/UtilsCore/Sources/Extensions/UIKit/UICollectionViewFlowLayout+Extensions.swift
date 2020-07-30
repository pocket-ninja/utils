//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

#if os(iOS)
public extension UICollectionViewFlowLayout {
    var workspaceSize: CGSize {
        return collectionView.flatMap(workspaceSize(in:)) ?? .zero
    }

    var maxContentOffset: CGPoint {
        return CGPoint(
            x: collectionViewContentSize.width - collectionSize.width,
            y: collectionViewContentSize.height - collectionSize.height
        )
    }

    var totalInsets: UIEdgeInsets {
        return sectionInset + (collectionView?.contentInset ?? .zero)
    }

    var collectionSize: CGSize {
        return collectionView?.bounds.size ?? .zero
    }

    var isVertical: Bool {
        return scrollDirection == .vertical
    }

    func workspaceSize(in collection: UICollectionView) -> CGSize {
        var size = collection.bounds.size
        size.width -= collection.safeAreaInsets.horizontal
        size.height -= collection.safeAreaInsets.vertical

        return CGSize(
            width: size.width - collection.contentInset.horizontal - sectionInset.horizontal,
            height: size.height - collection.contentInset.vertical - sectionInset.vertical
        )
    }

    func columns(fitting minimumSize: CGSize) -> Int {
        let fixedSide: CGFloat
        let minimumSide: CGFloat

        switch scrollDirection {
        case .vertical:
            fixedSide = workspaceSize.width
            minimumSide = minimumSize.width
        case .horizontal:
            fixedSide = workspaceSize.height
            minimumSide = minimumSize.height
        @unknown default:
            fatalError()
        }

        let freeSpace = fixedSide + minimumInteritemSpacing
        let columns = Int(freeSpace / (minimumSide + minimumInteritemSpacing))
        return columns
    }
}
#endif
