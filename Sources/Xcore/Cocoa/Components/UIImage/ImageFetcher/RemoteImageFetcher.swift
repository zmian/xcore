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

    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?) async throws -> Output {
        guard
            case let .url(value) = image.imageSource,
            let url = URL(string: value),
            url.host != nil
        else {
            throw ImageFetcherError.notFound
        }

        let (image, cacheType, cancelToken) = try await ImageDownloader.load(url: url)
        // Store the token cancel block so the request can be cancelled if needed.
        imageView?._imageFetcherCancelBlock = cancelToken
        return (image, cacheType)
    }

    func removeCache() {
        ImageDownloader.removeCache()
    }
}
