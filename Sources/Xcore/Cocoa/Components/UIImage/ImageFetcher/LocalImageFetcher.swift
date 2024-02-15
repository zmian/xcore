//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class LocalImageFetcher: ImageFetcher, Sendable {
    private let cache = Cache<String, UIImage>()

    func canHandle(_ image: ImageRepresentable) -> Bool {
        !image.imageSource.isRemoteUrl
    }

    func fetch(_ image: ImageRepresentable, in _: UIImageView?) async throws -> Output {
        switch image.imageSource {
            case let .uiImage(image):
                return (image, .memory)
            case let .url(value):
                let task = Task<Output, Error> {
                    if let image = UIImage(named: value, in: image.bundle, compatibleWith: nil) {
                        return (image, .memory)
                    }

                    let cacheKey = image.cacheKey

                    if let cacheKey, let image = await cache.value(forKey: cacheKey) {
                        return (image, .memory)
                    }

                    guard
                        let url = URL(string: value),
                        url.schemeType == .file,
                        let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data)
                    else {
                        throw ImageFetcherError.notFound
                    }

                    if let cacheKey {
                        await cache.setValue(image, forKey: cacheKey)
                    }

                    return (image, ImageSourceType.CacheType.disk)
                }

                return try await task.value
        }
    }

    func removeCache() {
        Task {
            await cache.removeAll()
        }
    }
}
