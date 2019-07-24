//
// UIImage+ImageRepresentable.swift
//
// Copyright © 2014 Xcore
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

extension UIImage {
    /// Fetch an image from the given source.
    public class func fetch(_ source: ImageRepresentable, callback: @escaping (_ image: UIImage?) -> Void) {
        UIImage.Fetcher.fetch(source, in: nil) { image, _ in
            DispatchQueue.main.asyncSafe {
                callback(image)
            }
        }
    }

    /// Download multiple remote images.
    public class func fetch(_ urls: [String], callback: @escaping (_ images: [(url: URL, image: UIImage)]) -> Void) {
        guard !urls.isEmpty else { return }

        var orderedObjects: [(url: URL, image: UIImage?)] = urls.compactMap(URL.init).filter { $0.host != nil }.compactMap { ($0, nil) }
        var downloadedImages = 0

        orderedObjects.forEach { object in
            ImageDownloader.download(url: object.url) { image, data, error, finished in
                downloadedImages += 1

                if let image = image, finished {
                    if let index = orderedObjects.firstIndex(where: { $0.url == object.url }) {
                        orderedObjects[index].image = image
                    }
                }

                if downloadedImages == urls.count {
                    let imagesAndUrls = orderedObjects.filter { $0.image != nil }.compactMap { (url: $0.url, image: $0.image!) }
                    DispatchQueue.main.asyncSafe {
                        callback(imagesAndUrls)
                    }
                }
            }
        }
    }
}
