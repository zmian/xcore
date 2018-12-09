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
        guard let fetcher = UIImage.Fetcher.registered.reversed().first(where: { $0.canHandle(image) }) else {
            callback(nil, .none)
            return
        }

        imageView?.imageRepresentableSource = image.imageSource
        fetcher.fetch(image, in: imageView, callback)
    }
}
