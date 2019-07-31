//
// CompositeImageFetcher.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

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
        let ids = fetchers.map { $0.id }

        guard let index = ids.firstIndex(of: fetcher.id) else {
            return
        }

        fetchers.remove(at: index)
    }
}

extension CompositeImageFetcher {
    var id: String {
        return fetchers.map { $0.id }.joined(separator: "_")
    }

    func canHandle(_ image: ImageRepresentable) -> Bool {
        return image.imageSource.isValid
    }

    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ResultBlock) {
        guard image.imageSource.isValid else {
            #if DEBUG
            Console.error("Unable to fetch image because of invalid image source.")
            #endif
            callback(nil, .none)
            return
        }

        // 1. Reverse fetchers so the third-party fetchers are always prioritized over
        //    built-in ones.
        // 2. Find the first one that can handle the request.
        // 3. Fetch the requested image.
        guard let fetcher = fetchers.reversed().first(where: { $0.canHandle(image) }) else {
            callback(nil, .none)
            return
        }

        imageView?.imageRepresentableSource = image.imageSource
        fetcher.fetch(image, in: imageView, callback)
    }

    func clearCache() {
        fetchers.forEach { $0.clearCache() }
    }
}
