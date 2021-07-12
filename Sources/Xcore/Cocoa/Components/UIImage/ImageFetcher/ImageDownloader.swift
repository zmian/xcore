//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SDWebImage

extension ImageSourceType.CacheType {
    fileprivate init(_ type: SDImageCacheType) {
        switch type {
            case .none:
                self = .none
            case .disk:
                self = .disk
            case .memory:
                self = .memory
            default:
                fatalError(because: .unknownCaseDetected(type))
        }
    }
}

/// An internal class to download remote images.
///
/// Currently, it uses `SDWebImage` for download requests.
enum ImageDownloader {
    typealias CancelToken = () -> Void

    /// Downloads the image at the given URL, if not present in cache or return the
    /// cached version otherwise.
    static func load(
        url: URL,
        completion: @escaping (
            _ image: UIImage?,
            _ data: Data?,
            _ error: Error?,
            _ finished: Bool,
            _ cacheType: ImageSourceType.CacheType
        ) -> Void
    ) -> CancelToken? {
        let token = SDWebImageManager.shared.loadImage(
            with: url,
            options: [.avoidAutoSetImage],
            progress: nil
        ) { image, data, error, cacheType, finished, _ in
            completion(image, data, error, finished, .init(cacheType))
        }

        return token?.cancel
    }

    /// Downloads the image from the given url.
    static func download(
        url: URL,
        completion: @escaping (
            _ image: UIImage?,
            _ data: Data?,
            _ error: Error?,
            _ finished: Bool
        ) -> Void
    ) {
        SDWebImageDownloader.shared.downloadImage(
            with: url,
            options: [],
            progress: nil
        ) { image, data, error, finished in
            completion(image, data, error, finished)
        }
    }

    static func removeCache() {
        SDImageCache.shared.apply {
            $0.clearMemory()
            $0.clearDisk()
            $0.deleteOldFiles()
        }
    }
}
