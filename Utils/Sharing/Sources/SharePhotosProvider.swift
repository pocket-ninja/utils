//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Photos
import UIKit

public struct SharePhotosProvider {
    public typealias Completion = (Bool, PHAsset?, Error?) -> Void

    public static func share(
        content: ShareContent,
        to album: String,
        then completion: @escaping Completion
    ) {
        createAlbum(named: album) { collection in
            share(content: content, to: collection, then: completion)
        }
    }

    public static func share(
        content: ShareContent,
        to collection: PHAssetCollection? = nil,
        then completion: @escaping Completion
    ) {
        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            guard let request = content.photosChangeRequest else {
                return
            }

            request.creationDate = Date()
            placeholder = request.placeholderForCreatedAsset

            guard let assetCollection = collection, let assetPlaceholder = placeholder else {
                return
            }

            let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
            let collectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection, assets: assets)
            collectionChangeRequest?.addAssets([assetPlaceholder] as NSFastEnumeration)

        }, completionHandler: { success, error in
            var asset: PHAsset?
            if success, let id = placeholder?.localIdentifier, id.count > 0 {
                asset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject
            }

            DispatchQueue.main.async {
                completion(success, asset, error)
            }
        })
    }

    public static func createAlbum(named name: String, then completion: @escaping (PHAssetCollection?) -> Void) {
        if name.isEmpty {
            completion(nil)
            return
        }

        if let existing = album(named: name) {
            completion(existing)
            return
        }

        var placeholder: PHObjectPlaceholder?

        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            placeholder = request.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            let ids: [String] = [placeholder?.localIdentifier].compactMap { $0 }
            let result = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: ids, options: nil)
            let album = result.firstObject
            DispatchQueue.main.async {
                completion(album)
            }
        })
    }

    public static func album(named name: String) -> PHAssetCollection? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", name)
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        return result.firstObject
    }
}

private extension ShareContent {
    var photosChangeRequest: PHAssetChangeRequest? {
        switch item {
        case let .file(url):
            return PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        case let .image(image, _):
            return PHAssetChangeRequest.creationRequestForAsset(from: image)
        case let .data(data, type):
            if type.conforms(to: .image), let image = UIImage(data: data) {
                return PHAssetChangeRequest.creationRequestForAsset(from: image)
            } else {
                return nil
            }
        case .text:
            return nil
        }
    }
}
