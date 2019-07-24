//
// RemoteImageFetcher.swift
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

final class RemoteImageFetcher: ImageFetcher {
    func canHandle(_ image: ImageRepresentable) -> Bool {
        return image.imageSource.isRemoteUrl
    }

    /// Loads remote image either via from cache or web.
    ///
    /// - Parameters:
    ///   - image: The image requested to be fetched.
    ///   - imageView: An optional property if this image will be set on the image
    ///                view.
    ///   - callback: A block with the `UIImage` object and cache type if image
    ///               successfully fetched. Otherwise, `nil`.
    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ResultBlock) {
        guard case .url(let value) = image.imageSource, let url = URL(string: value), url.host != nil else {
            callback(nil, .none)
            return
        }

        let cancelToken = ImageDownloader.load(url: url) { image, data, error, finished, cacheType in
            guard finished else {
                return
            }

            guard let image = image else {
                callback(nil, .none)
                return
            }

            callback(image, cacheType)
        }

        // Store the token cancel block so the request can be cancelled if needed.
        imageView?._imageFetcherCancelBlock = cancelToken
    }

    func clearCache() {
        ImageDownloader.clearCache()
    }
}
