//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
@_implementationOnly import SDWebImage

/// An internal class to download remote images.
///
/// Currently, it uses `SDWebImage` for download requests.
enum ImageDownloader {
    /// Downloads the image at the given URL, if not present in cache or return the
    /// cached version otherwise.
    static func load(url: URL) async throws -> (UIImage, ImageSourceType.CacheType) {
        var token: SDWebImageCombinedOperation?
        let cancel = ImageDownloaderCancelToken { token?.cancel() }

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                token = SDWebImageManager.shared.loadImage(
                    with: url,
                    options: [.avoidAutoSetImage],
                    progress: nil
                ) { image, _, error, cacheType, _, _ in
                    if Task.isCancelled {
                        token?.cancel()
                        continuation.resume(throwing: CancellationError())
                    } else if let image {
                        continuation.resume(returning: (image, .init(cacheType)))
                    } else {
                        continuation.resume(throwing: error ?? ImageFetcherError.notFound)
                    }
                }
            }
        } onCancel: {
            cancel()
        }
    }

    /// Downloads the image from the given url.
    static func download(url: URL) async throws -> UIImage {
        var token: SDWebImageDownloadToken?
        let cancel = ImageDownloaderCancelToken { token?.cancel() }

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                token = SDWebImageDownloader.shared.downloadImage(
                    with: url,
                    options: [],
                    progress: nil
                ) { image, _, error, finished in
                    if Task.isCancelled {
                        token?.cancel()
                        continuation.resume(throwing: CancellationError())
                    }

                    if !finished {
                        return
                    }

                    if let image {
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(throwing: error ?? ImageFetcherError.notFound)
                    }
                }
            }
        } onCancel: {
            cancel()
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
