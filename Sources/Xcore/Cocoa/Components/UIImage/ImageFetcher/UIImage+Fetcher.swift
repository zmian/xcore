//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
private import SDWebImage
import UIKit

// MARK: - Namespace

extension UIImage {
    public enum Fetcher {}
}

// MARK: - Registration

extension UIImage.Fetcher {
    /// The registered list of fetchers.
    private static let shared = CompositeImageFetcher([
        DefaultImageFetcher()
    ])

    /// Register the given fetcher if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate fetchers.
    public static func register(_ fetcher: ImageFetcher) {
        shared.add(fetcher)
    }

    // MARK: - Cache Management

    public static func removeCache() {
        shared.removeCache()
    }

    @MainActor
    static func fetch(
        _ image: ImageRepresentable,
        in imageView: UIImageView? = nil
    ) async throws -> ImageFetcher.Output {
        try await shared.fetch(image, in: imageView)
    }
}

extension UIImageView {
    @MainActor
    private enum AssociatedKey {
        static var imageSetTask = "imageSetTask"
        static var imageSetRequestID = "imageSetRequestID"
        static var imageRepresentableSource = "imageRepresentableSource"
        static var imageFetcherCancelBlock = "imageFetcherCancelBlock"
    }

    /// The task performing the current fetch, transform, and image assignment.
    var imageSetTask: Task<Void, Never>? {
        get { associatedObject(&AssociatedKey.imageSetTask) }
        set { setAssociatedObject(&AssociatedKey.imageSetTask, value: newValue) }
    }

    /// Identifies the set operation independently of its underlying fetch.
    var imageSetRequestID: UUID? {
        get { associatedObject(&AssociatedKey.imageSetRequestID) }
        set { setAssociatedObject(&AssociatedKey.imageSetRequestID, value: newValue) }
    }

    /// The `ImageSourceType` object associated with the receiver.
    var imageRepresentableSource: ImageSourceType? {
        get { associatedObject(&AssociatedKey.imageRepresentableSource) }
        set { setAssociatedObject(&AssociatedKey.imageRepresentableSource, value: newValue) }
    }

    /// The image fetch cancel block for the current fetch request.
    var _imageFetcherCancelBlock: ImageDownloaderCancelToken? {
        get { associatedObject(&AssociatedKey.imageFetcherCancelBlock) }
        set { setAssociatedObject(&AssociatedKey.imageFetcherCancelBlock, value: newValue) }
    }

    /// Cancels the current image load and prevents its result from being applied.
    ///
    /// A synchronous transform already in progress may finish, but its result is
    /// discarded without invoking the completion callback or loading a fallback.
    ///
    /// - SeeAlso: `setImage(_:duration:_:)`
    public func cancelSetImageRequest() {
        imageSetRequestID = nil
        imageSetTask?.cancel()
        imageSetTask = nil
        cancelImageFetch()
    }

    func cancelImageFetch() {
        sd_cancelCurrentImageLoad()
        _imageFetcherCancelBlock?()
        _imageFetcherCancelBlock = nil
    }
}

struct ImageDownloaderCancelToken: @unchecked Sendable {
    let cancel: () -> Void

    func callAsFunction() {
        cancel()
    }
}
#endif
