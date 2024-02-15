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
    static func load(url: URL) async throws -> (UIImage, ImageSourceType.CacheType, ImageDownloaderCancelToken?) {
        try await withCheckedThrowingContinuation { continuation in
            var token: SDWebImageCombinedOperation?

            token = SDWebImageManager.shared.loadImage(
                with: url,
                options: [.avoidAutoSetImage],
                progress: nil
            ) { image, _, error, cacheType, _, _ in
                if Task.isCancelled {
                    token?.cancel()
                    continuation.resume(throwing: CancellationError())
                } else if let image {
                    let cancel = token?.cancel
                    continuation.resume(returning: (image, .init(cacheType), .init { cancel?() }))
                } else {
                    continuation.resume(throwing: error ?? ImageFetcherError.notFound)
                }
            }

            if Task.isCancelled {
                token?.cancel()
            }
        }
    }

    /// Downloads the image from the given url.
    static func download(url: URL) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            var token: SDWebImageDownloadToken?

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

            if Task.isCancelled {
                token?.cancel()
            }
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

struct ImageDownloaderCancelToken: @unchecked Sendable {
    let cancel: () -> Void

    func callAsFunction() {
        cancel()
    }
}
