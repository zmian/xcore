//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol ImageFetcher {
    typealias ResultBlock = (_ image: UIImage?, _ cacheType: ImageSourceType.CacheType) -> Void

    /// A unique id for the image fetcher.
    var id: String { get }

    func canHandle(_ image: ImageRepresentable) -> Bool

    /// Fetch the image.
    ///
    /// - Parameters:
    ///   - image: The image requested to be fetched.
    ///   - imageView: An optional property if this image will be set on the image view.
    ///   - callback: The callback to let the handler know when the image is fetched.
    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ResultBlock)

    func removeCache()
}

extension ImageFetcher {
    public var id: String {
        name(of: self)
    }
}
