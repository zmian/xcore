//
// LocalImageFetcher.swift
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

final class LocalImageFetcher: ImageFetcher {
    private let cache = NSCache<NSString, UIImage>()

    func canHandle(_ image: ImageRepresentable) -> Bool {
        return !image.imageSource.isRemoteUrl
    }

    func fetch(_ image: ImageRepresentable, in imageView: UIImageView?, _ callback: @escaping ResultBlock) {
        switch image.imageSource {
            case .uiImage(let image):
                callback(image, .memory)
            case .url(let value):
                if let image = UIImage(named: value, in: image.bundle, compatibleWith: nil) {
                    callback(image, .memory)
                    return
                }

                let cacheKey = image.cacheKey as NSString?

                if let cacheKey = cacheKey, let image = cache.object(forKey: cacheKey) {
                    callback(image, .memory)
                    return
                }

                DispatchQueue.global(qos: .userInteractive).asyncSafe { [weak self] in
                    guard
                        let strongSelf = self,
                        let url = URL(string: value),
                        url.schemeType == .file,
                        let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data)
                    else {
                        DispatchQueue.main.asyncSafe {
                            callback(nil, .none)
                        }
                        return
                    }

                    if let cacheKey = cacheKey {
                        strongSelf.cache.setObject(image, forKey: cacheKey)
                    }

                    DispatchQueue.main.asyncSafe {
                        callback(image, .disk)
                    }
                }
        }
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
