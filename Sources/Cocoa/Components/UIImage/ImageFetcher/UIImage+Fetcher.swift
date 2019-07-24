//
// UIImage+Fetcher.swift
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

// MARK: - Namespace

extension UIImage {
    public enum Fetcher { }
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

    public static func clearCache() {
        registered.clearCache()
    }

    static func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ImageFetcher.ResultBlock) {
        registered.fetch(image, in: imageView, callback)
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
    /// `setImage(_:alwaysAnimate:animationDuration:_:)` method.
    ///
    /// - seealso: `setImage(_:alwaysAnimate:animationDuration:_:)`
    public func cancelSetImageRequest() {
        sd_cancelCurrentImageLoad()
        _imageFetcherCancelBlock?()
    }
}
