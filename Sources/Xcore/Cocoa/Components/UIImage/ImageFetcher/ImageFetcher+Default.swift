//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class DefaultImageFetcher: ImageFetcher {
    private let cache = Cache<String, UIImage>()

    func canHandle(_ image: ImageRepresentable) -> Bool {
        image.imageSource.isValid
    }

    func fetch(_ image: ImageRepresentable, in _: UIImageView?) async throws -> Output {
        switch image.imageSource {
            case let .uiImage(image):
                return (image, .memory)
            case let .url(value):
                // Bundle image
                if let image = UIImage(named: value, in: image.bundle, compatibleWith: nil) {
                    return (image, .memory)
                }

                // If cached then return it from the cache.
                if let cacheKey = image.cacheKey, let image = cache[cacheKey] {
                    return (image, .memory)
                }

                guard let url = URL(string: value) else {
                    throw ImageFetcherError.notFound
                }

                // File url
                if url.isFileURL {
                    let data = try Data(contentsOf: url)

                    guard let image = UIImage(data: data) else {
                        throw ImageFetcherError.notFound
                    }

                    if let cacheKey = image.cacheKey {
                        cache[cacheKey] = image
                    }

                    return (image, .disk)
                } else if image.imageSource.isRemoteUrl {
                    // Remote url
                    return try await ImageDownloader.load(url: url)
                }

                throw ImageFetcherError.notFound
        }
    }

    func removeCache() {
        ImageDownloader.removeCache()
        cache.removeAll()
    }
}
