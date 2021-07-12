//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol ImageFetcher {
    typealias ResultBlock = (Result<(image: UIImage, cacheType: ImageSourceType.CacheType), Error>) -> Void

    /// A unique id for the image fetcher.
    var id: String { get }

    func canHandle(_ image: ImageRepresentable) -> Bool

    /// Fetch the image.
    ///
    /// - Parameters:
    ///   - image: The image requested to be fetched.
    ///   - imageView: An optional property if this image will be set on the image
    ///                view.
    ///   - callback: The callback to let the handler know when the image is
    ///               fetched.
    func fetch(
        _ image: ImageRepresentable,
        in imageView: UIImageView?,
        _ callback: @escaping ResultBlock
    )

    func removeCache()
}

extension ImageFetcher {
    public var id: String {
        name(of: self)
    }
}

enum ImageFetcherError: Error {
    case notFound
}

extension Result where Success == (image: UIImage, cacheType: ImageSourceType.CacheType) {
    func trimCache() -> Result<UIImage, Error> {
        switch self {
            case let .success(value):
                return .success(value.image)
            case let .failure(error):
                return .failure(error)
        }
    }
}
