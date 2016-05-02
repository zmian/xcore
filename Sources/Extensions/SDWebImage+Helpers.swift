//
// SDWebImage+Helpers.swift
//
// Copyright © 2014 Zeeshan Mian
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
import SDWebImage

public extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    public func remoteOrLocalImage(named: String, alwaysAnimate: Bool = false, callback: ((image: UIImage) -> Void)? = nil) {
        guard !named.isBlank else { image = nil; return }

        if let url = NSURL(string: named) where url.host != nil {
            self.sd_setImageWithURL(url) {[weak self] (image, _, cacheType, _) in
                guard let image = image else { return }
                defer {
                    dispatch.async.main {
                        callback?(image: image)
                    }
                }
                if let weakSelf = self where (alwaysAnimate || cacheType != SDImageCacheType.Memory) {
                    weakSelf.alpha = 0
                    UIView.animateWithDuration(0.5) {
                        weakSelf.alpha = 1
                    }
                }
            }
        } else {
            dispatch.async.bg(.UserInitiated) {[weak self] in
                guard let weakSelf = self, image = UIImage(named: named) else { return }
                dispatch.async.main {
                    defer { callback?(image: image) }

                    if alwaysAnimate {
                        weakSelf.alpha = 0
                        weakSelf.image = image
                        UIView.animateWithDuration(0.5) {
                            weakSelf.alpha = 1
                        }
                    } else {
                        weakSelf.image = image
                    }
                }
            }
        }
    }
}

public extension UIImage {
    /// Automatically detect and load the image from local or a remote url.
    public class func remoteOrLocalImage(named: String, bundle: NSBundle? = nil, callback: (image: UIImage) -> Void) {
        guard !named.isBlank else { return }

        if let url = NSURL(string: named) where url.host != nil {
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: [],
                progress: { receivedSize, expectedSize in

                }, completed: { image, data, error, finished in
                    guard let image = image where finished else { return }
                    dispatch.async.main {
                        callback(image: image)
                    }
                }
            )
        } else {
            dispatch.async.bg(.UserInitiated) {
                guard let image = UIImage(named: named, inBundle: bundle, compatibleWithTraitCollection: nil) else { return }
                dispatch.async.main {
                    callback(image: image)
                }
            }
        }
    }

    /// Download multiple remote images.
    public class func downloadImages(urls: [String], callback: (images: [(url: NSURL, image: UIImage)]) -> Void) {
        guard !urls.isEmpty else { return }

        var orderedObjects: [(url: NSURL, image: UIImage?)] = urls.flatMap(NSURL.init).filter { $0.host != nil }.flatMap { ($0, nil) }
        var downloadedImages = 0

        orderedObjects.forEach { object in
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(object.url, options: [],
                progress: { receivedSize, expectedSize in

                }, completed: { image, data, error, finished in
                    downloadedImages += 1

                    if let image = image where finished {
                        if let index = (orderedObjects.indexOf { $0.url == object.url }) {
                            orderedObjects[index].image = image
                        }
                    }

                    if downloadedImages == urls.count {
                        let imagesAndUrls = orderedObjects.filter { $0.image != nil }.flatMap { (url: $0.url, image: $0.image!) }
                        dispatch.async.main {
                            callback(images: imagesAndUrls)
                        }
                    }
                }
            )
        }
    }
}
