//
// CompositeImageFetcher.swift
//
// Copyright © 2018 Zeeshan Mian
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

final class CompositeImageFetcher: ImageFetcher {
    static func canHandle(_ image: ImageRepresentable) -> Bool {
        return image.imageSource.isValid
    }

    static func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ResultBlock) {
        guard image.imageSource.isValid else {
            #if DEBUG
            Console.error("Unable to fetch image because of invalid image source.")
            #endif
            callback(nil, .none)
            return
        }

        // 1. Reverse fetchers so the third-party fetchers are always prioritized over built-in ones.
        // 2. Find the first one that can handle the request.
        // 3. Fetch the requested image.
        guard let fetcher = UIImage.fetchers.reversed().first(where: { $0.canHandle(image) }) else {
            callback(nil, .none)
            return
        }

        imageView?.imageRepresentableSource = image.imageSource
        fetcher.fetch(image, in: imageView, callback)
    }
}

extension UIImage {
    fileprivate static var fetchers: [ImageFetcher.Type] = [RemoteImageFetcher.self, LocalImageFetcher.self]

    public static func register(_ fetcher: ImageFetcher.Type) {
        fetchers.append(fetcher)
    }
}

extension UIImageView {
    private struct AssociatedKey {
        static var imageRepresentableSource = "imageRepresentableSource"
        static var imageFetcherCancelBlock = "imageFetcherCancelBlock"
    }

    /// The `ImageSourceType` object associated with the receiver.
    var imageRepresentableSource: ImageSourceType? {
        get { return associatedObject(&AssociatedKey.imageRepresentableSource) }
        set { setAssociatedObject(&AssociatedKey.imageRepresentableSource, value: newValue) }
    }

    /// The image fetch cancel block for the current fetch request.
    var _imageFetcherCancelBlock: (() -> Void)? {
        get { return associatedObject(&AssociatedKey.imageFetcherCancelBlock) }
        set { setAssociatedObject(&AssociatedKey.imageFetcherCancelBlock, value: newValue) }
    }

    /// Cancel any pending or in-flight image fetch/set request dispatched via
    /// `setImage(_:transform:alwaysAnimate:animationDuration:_:)` method.
    ///
    /// - seealso: `setImage(_:transform:alwaysAnimate:animationDuration:_:)`
    public func cancelSetImageRequest() {
        sd_cancelCurrentImageLoad()
        _imageFetcherCancelBlock?()
    }
}
