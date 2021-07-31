//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class RemoteImageFetcher: ImageFetcher {
    func canHandle(_ image: ImageRepresentable) -> Bool {
        image.imageSource.isRemoteUrl
    }

    /// Loads remote image either via from cache or web.
    ///
    /// - Parameters:
    ///   - image: The image requested to be fetched.
    ///   - imageView: An optional property if this image will be set on the image
    ///     view.
    ///   - callback: A closure with the `UIImage` object and cache type if image
    ///     successfully fetched; otherwise, `nil`.
    func fetch(
        _ image: ImageRepresentable,
        in imageView: UIImageView?,
        _ callback: @escaping ResultBlock
    ) {
        guard
            case let .url(value) = image.imageSource,
            let url = URL(string: value),
            url.host != nil
        else {
            callback(.failure(ImageFetcherError.notFound))
            return
        }

        let cancelToken = ImageDownloader.load(url: url) { image, _, error, finished, cacheType in
            guard finished else {
                return
            }

            guard let image = image else {
                callback(.failure(error ?? ImageFetcherError.notFound))
                return
            }

            callback(.success((image, cacheType)))
        }

        // Store the token cancel block so the request can be cancelled if needed.
        imageView?._imageFetcherCancelBlock = cancelToken
    }

    func removeCache() {
        ImageDownloader.removeCache()
    }
}
