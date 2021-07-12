//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Namespace

extension UIImage {
    public enum Fetcher {}
}

// MARK: - Registration

extension UIImage.Fetcher {
    /// The registered list of fetchers.
    private static let registered = CompositeImageFetcher([
        RemoteImageFetcher(),
        LocalImageFetcher()
    ])

    /// Register the given fetcher if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate fetchers.
    public static func register(_ fetcher: ImageFetcher) {
        registered.add(fetcher)
    }

    // MARK: - Cache Management

    public static func removeCache() {
        registered.removeCache()
    }

    static func fetch(
        _ image: ImageRepresentable,
        in imageView: UIImageView?,
        _ callback: @escaping ImageFetcher.ResultBlock
    ) {
        registered.fetch(image, in: imageView, callback)
    }
}

extension UIImageView {
    private enum AssociatedKey {
        static var imageRepresentableSource = "imageRepresentableSource"
        static var imageFetcherCancelBlock = "imageFetcherCancelBlock"
    }

    /// The `ImageSourceType` object associated with the receiver.
    var imageRepresentableSource: ImageSourceType? {
        get { associatedObject(&AssociatedKey.imageRepresentableSource) }
        set { setAssociatedObject(&AssociatedKey.imageRepresentableSource, value: newValue) }
    }

    /// The image fetch cancel block for the current fetch request.
    var _imageFetcherCancelBlock: (() -> Void)? {
        get { associatedObject(&AssociatedKey.imageFetcherCancelBlock) }
        set { setAssociatedObject(&AssociatedKey.imageFetcherCancelBlock, value: newValue) }
    }

    /// Cancel any pending or in-flight image fetch/set request dispatched via
    /// `setImage(_:alwaysAnimate:animationDuration:_:)` method.
    ///
    /// - SeeAlso: `setImage(_:alwaysAnimate:animationDuration:_:)`
    public func cancelSetImageRequest() {
        sd_cancelCurrentImageLoad()
        _imageFetcherCancelBlock?()
    }
}
