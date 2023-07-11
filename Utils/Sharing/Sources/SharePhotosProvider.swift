//
//  Copyright © 2020 pocket-ninja. All rights reserved.
//

import Photos
import UIKit

public struct SharePhotosProvider {
    public typealias Completion = (Bool, PHFetchResult<PHAsset>, Error?) -> Void

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
        var placeholders: [PHObjectPlaceholder] = []
        
        PHPhotoLibrary.shared().performChanges({
            placeholders = content.photosChangeRequests.compactMap { request in
                request.creationDate = Date()
                return request.placeholderForCreatedAsset
            }

            guard let assetCollection = collection, !placeholders.isEmpty else {
                return
            }

            let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
            let collectionChangeRequest = PHAssetCollectionChangeRequest(for: assetCollection, assets: assets)
            collectionChangeRequest?.addAssets(placeholders as NSFastEnumeration)

        }, completionHandler: { success, error in
            let ids = placeholders.map(\.localIdentifier)
            let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: ids, options: nil)

            DispatchQueue.main.async {
                completion(success, fetchedAssets, error)
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
    var photosChangeRequests: [PHAssetChangeRequest] {
        var requests: [PHAssetChangeRequest?]
        
        switch item {
        case let .file(url):
            requests = [PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)]
            
        case let .files(urls):
            requests = urls.map {
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: $0)
            }
            
        case let .image(image, _):
            requests = [PHAssetChangeRequest.creationRequestForAsset(from: image)]
            
        case let .data(data, type):
            if type.conforms(to: .image), let image = UIImage(data: data) {
                requests = [PHAssetChangeRequest.creationRequestForAsset(from: image)]
            } else {
                requests = []
            }
            
        case .text:
            requests = []
        }
        
        return requests.compactMap { $0 }
    }
}
