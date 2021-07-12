//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class LocalImageFetcher: ImageFetcher {
    private let cache = NSCache<NSString, UIImage>()

    func canHandle(_ image: ImageRepresentable) -> Bool {
        !image.imageSource.isRemoteUrl
    }

    func fetch(
        _ image: ImageRepresentable,
        in imageView: UIImageView?,
        _ callback: @escaping ResultBlock
    ) {
        switch image.imageSource {
            case let .uiImage(image):
                callback(.success((image, .memory)))
            case let .url(value):
                if let image = UIImage(named: value, in: image.bundle, compatibleWith: nil) {
                    callback(.success((image, .memory)))
                    return
                }

                let cacheKey = image.cacheKey as NSString?

                if let cacheKey = cacheKey, let image = cache.object(forKey: cacheKey) {
                    callback(.success((image, .memory)))
                    return
                }

                DispatchQueue.global(qos: .userInteractive).asyncSafe { [weak self] in
                    guard
                        let strongSelf = self,
                        let url = URL(string: value),
                        url.schemeType == .file,
                        let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data)
                    else {
                        DispatchQueue.main.asyncSafe {
                            callback(.failure(ImageFetcherError.notFound))
                        }
                        return
                    }

                    if let cacheKey = cacheKey {
                        strongSelf.cache.setObject(image, forKey: cacheKey)
                    }

                    DispatchQueue.main.asyncSafe {
                        callback(.success((image, .disk)))
                    }
                }
        }
    }

    func removeCache() {
        cache.removeAllObjects()
    }
}
