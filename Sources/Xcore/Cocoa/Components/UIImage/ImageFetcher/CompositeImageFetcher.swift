//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import OSLog

final class CompositeImageFetcher: ImageFetcher, ExpressibleByArrayLiteral {
    /// The registered list of fetchers.
    private var fetchers: [ImageFetcher] = []

    init(_ fetchers: [ImageFetcher]) {
        self.fetchers = fetchers
    }

    init(arrayLiteral elements: ImageFetcher...) {
        self.fetchers = elements
    }

    /// Add given fetcher if it's not already included in the collection.
    ///
    /// - Note: This method ensures there are no duplicate fetchers.
    func add(_ fetcher: ImageFetcher) {
        guard !fetchers.contains(where: { $0.id == fetcher.id }) else {
            return
        }

        fetchers.append(fetcher)
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
        let ids = fetchers.map(\.id)

        guard let index = ids.firstIndex(of: fetcher.id) else {
            return
        }

        fetchers.remove(at: index)
    }
}

extension CompositeImageFetcher {
    var id: String {
        fetchers.map(\.id).joined(separator: "_")
    }

    func canHandle(_ image: ImageRepresentable) -> Bool {
        image.imageSource.isValid
    }

    @MainActor
    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?) async throws -> Output {
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
        guard let fetcher = fetchers.reversed().first(where: { $0.canHandle(image) }) else {
            throw ImageFetcherError.notFound
        }

        imageView?.imageRepresentableSource = image.imageSource
        return try await fetcher.fetch(image, in: imageView)
    }

    func removeCache() {
        fetchers.forEach { $0.removeCache() }
    }
}
