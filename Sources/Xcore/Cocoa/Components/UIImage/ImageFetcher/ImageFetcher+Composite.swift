//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit
import OSLog

final class CompositeImageFetcher: ImageFetcher, ExpressibleByArrayLiteral, @unchecked Sendable {
    private let fetchers = LockIsolated([ImageFetcher]())

    init(_ fetchers: [ImageFetcher]) {
        self.fetchers.setValue(fetchers.uniqued(\.id))
    }

    init(arrayLiteral elements: ImageFetcher...) {
        self.fetchers.setValue(elements.uniqued(\.id))
    }

    /// Add given fetcher if it's not already included in the collection.
    ///
    /// - Note: This method ensures there are no duplicate fetchers.
    func add(_ fetcher: ImageFetcher) {
        fetchers.withValue { list in
            guard !list.contains(where: { $0.id == fetcher.id }) else {
                return
            }
            list.append(fetcher)
        }
    }

    /// Add list of given fetchers if they are not already included in the
    /// collection.
    ///
    /// - Note: This method ensures there are no duplicate fetchers.
    func add(_ fetchers: [ImageFetcher]) {
        fetchers.forEach(add)
    }

    /// Removes the given fetcher.
    func remove(_ fetcher: ImageFetcher) {
        fetchers.withValue { list in
            guard let index = list.firstIndex(where: { $0.id == fetcher.id }) else {
                return
            }
            list.remove(at: index)
        }
    }
}

extension CompositeImageFetcher {
    var id: String {
        fetchers.value.map(\.id).joined(separator: "_")
    }

    func canHandle(_ image: ImageRepresentable) -> Bool {
        image.imageSource.isValid
    }

    @MainActor
    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?) async throws -> Output {
        // Cancel any existing in-flight image request.
        imageView?.cancelSetImageRequest()

        guard image.imageSource.isValid else {
            #if DEBUG
            Logger.xc.error("Unable to fetch image because of invalid image source: \(String(describing: image.imageSource), privacy: .public)")
            #endif
            throw ImageFetcherError.invalidImageSource
        }

        // 1. Reverse fetchers so the third-party fetchers are always prioritized over
        //    built-in ones.
        // 2. Find the first one that can handle the request.
        // 3. Fetch the requested image.
        let registered = fetchers.value
        guard let fetcher = registered.reversed().first(where: { $0.canHandle(image) }) else {
            throw ImageFetcherError.notFound
        }

        imageView?.imageRepresentableSource = image.imageSource

        let task = Task {
            try await fetcher.fetch(image, in: imageView)
        }

        // Store the token cancel block so the request can be cancelled if needed.
        imageView?._imageFetcherCancelBlock = .init {
            task.cancel()
        }

        return try await task.value
    }

    func removeCache() {
        fetchers.value.forEach { $0.removeCache() }
    }
}
#endif