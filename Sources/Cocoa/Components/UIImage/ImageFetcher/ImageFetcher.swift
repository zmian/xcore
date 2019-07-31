//
// ImageFetcher.swift
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

    func clearCache()
}

extension ImageFetcher {
    public var id: String {
        return name(of: self)
    }
}
