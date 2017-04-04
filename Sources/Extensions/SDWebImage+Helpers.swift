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
    public func remoteOrLocalImage(_ named: String, alwaysAnimate: Bool = false, animationDuration: TimeInterval = 0.5, callback: ((_ image: UIImage?) -> Void)? = nil) {
        guard !named.isBlank else {
            image = nil
            callback?(nil)
            return
        }

        if let url = URL(string: named), url.host != nil {
            self.sd_setImage(with: url) {[weak self] (image, _, cacheType, _) in
                guard let image = image else {
                    dispatch.async.main {
                        callback?(nil)
                    }
                    return
                }

                defer {
                    dispatch.async.main {
                        callback?(image)
                    }
                }

                if let weakSelf = self, (alwaysAnimate || cacheType != SDImageCacheType.memory) {
                    weakSelf.alpha = 0
                    UIView.animate(withDuration: animationDuration) {
                        weakSelf.alpha = 1
                    }
                }
            }
        } else {
            dispatch.async.bg(.userInitiated) {[weak self] in
                guard let weakSelf = self, let image = UIImage(named: named) else {
                    dispatch.async.main {
                        callback?(nil)
                    }
                    return
                }

                dispatch.async.main {
                    defer { callback?(image) }

                    if alwaysAnimate {
                        weakSelf.alpha = 0
                        weakSelf.image = image
                        UIView.animate(withDuration: animationDuration) {
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
    public class func remoteOrLocalImage(_ named: String, bundle: Bundle? = nil, callback: @escaping (_ image: UIImage?) -> Void) {
        guard !named.isBlank else {
            callback?(nil)
            return
        }

        if let url = URL(string: named), url.host != nil {
            SDWebImageDownloader.shared().downloadImage(with: url, options: [],
                progress: { receivedSize, expectedSize in

                },
                completed: { image, data, error, finished in
                    guard let image = image, finished else {
                        dispatch.async.main {
                            callback(nil)
                        }
                        return
                    }
                    dispatch.async.main {
                        callback(image)
                    }
                }
            )
        } else {
            dispatch.async.bg(.userInitiated) {
                guard let image = UIImage(named: named, in: bundle, compatibleWith: nil) else {
                    dispatch.async.main {
                        callback(nil)
                    }
                    return
                }
                dispatch.async.main {
                    callback(image)
                }
            }
        }
    }

    /// Download multiple remote images.
    public class func downloadImages(_ urls: [String], callback: @escaping (_ images: [(url: URL, image: UIImage)]) -> Void) {
        guard !urls.isEmpty else { return }

        var orderedObjects: [(url: URL, image: UIImage?)] = urls.flatMap(URL.init).filter { $0.host != nil }.flatMap { ($0, nil) }
        var downloadedImages = 0

        orderedObjects.forEach { object in
            SDWebImageDownloader.shared().downloadImage(with: object.url, options: [],
                progress: { receivedSize, expectedSize in

                }, completed: { image, data, error, finished in
                    downloadedImages += 1

                    if let image = image, finished {
                        if let index = (orderedObjects.index { $0.url == object.url }) {
                            orderedObjects[index].image = image
                        }
                    }

                    if downloadedImages == urls.count {
                        let imagesAndUrls = orderedObjects.filter { $0.image != nil }.flatMap { (url: $0.url, image: $0.image!) }
                        dispatch.async.main {
                            callback(imagesAndUrls)
                        }
                    }
                }
            )
        }
    }
}
