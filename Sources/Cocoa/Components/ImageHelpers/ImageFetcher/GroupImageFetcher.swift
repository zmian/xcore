//
// GroupImageFetcher.swift
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

final class GroupImageFetcher: ImageFetcher {
    static func canHandle(_ image: ImageRepresentable) -> Bool {
        return true
    }

    static func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, callback: @escaping ResultBlock) {
        // 1. Reverse fetchers so the third-party fecthers are always prioritized over built-in ones.
        // 2. Find the first one that can handle the request.
        // 3. Fetch the requested image.
        guard let fetcher = UIImage.fetchers.reversed().first(where: { $0.canHandle(image) }) else {
            callback(nil, .none)
            return
        }

        fetcher.fetch(image, in: imageView, callback: callback)
    }
}
