//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A protocol for objects responsible for fetching images asynchronously.
public protocol ImageFetcher {
    /// The output type containing the fetched image and its cache type.
    typealias Output = (image: UIImage, cacheType: ImageSourceType.CacheType)

    /// A unique id for the image fetcher.
    var id: String { get }

    /// Determines whether the image fetcher can handle the specified image.
    ///
    /// - Parameter image: The image to be evaluated.
    /// - Returns: A boolean value indicating whether the image fetcher can handle
    ///   the specified image.
    func canHandle(_ image: ImageRepresentable) -> Bool

    /// Asynchronously fetches the specified image.
    ///
    /// - Parameters:
    ///   - image: The image requested to be fetched.
    ///   - imageView: An optional property indicating the `UIImageView` where the
    ///     fetched image will be set.
    /// - Returns: A tuple containing the fetched `UIImage` object and its cache
    ///   type if the image is successfully fetched; otherwise, throws an error.
    /// - Throws: An error if the image fetching operation encounters any issues.
    @MainActor
    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?) async throws -> Output

    /// Removes the cached image data associated with the image fetcher.
    func removeCache()
}

extension ImageFetcher {
    public var id: String {
        name(of: self)
    }
}

enum ImageFetcherError: Error {
    case notFound
    case invalidImageSource
}
