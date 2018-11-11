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

extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - seealso: `setImage(_:alwaysAnimate:animationDuration:callback:)`
    func remoteOrLocalImage(_ image: ImageRepresentable?, transform: ImageTransform?, alwaysAnimate: Bool, animationDuration: TimeInterval, callback: ((_ image: UIImage?) -> Void)?) {
        guard let imageRepresentable = image, imageRepresentable.imageSource.isValid else {
            self.image = nil
            callback?(nil)
            return
        }

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else { return }
            CompositeImageFetcher.fetch(imageRepresentable, in: strongSelf) { [weak self] image, cacheType in
                self?.postProcess(
                    image: image,
                    source: imageRepresentable,
                    transform: transform,
                    alwaysAnimate: (alwaysAnimate || cacheType.isRemote),
                    animationDuration: animationDuration,
                    callback: callback
                )
            }
        }
    }

    private func postProcess(image: UIImage?, source: ImageRepresentable, transform: ImageTransform?, alwaysAnimate: Bool, animationDuration: TimeInterval, callback: ((_ image: UIImage?) -> Void)?) {
        guard var image = image else {
            DispatchQueue.main.async {
                callback?(nil)
            }
            return
        }

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            image = image.process(source, using: transform)

            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }

                defer { callback?(image) }

                if alwaysAnimate {
                    strongSelf.alpha = 0
                    strongSelf.image = image
                    UIView.animate(withDuration: animationDuration) {
                        strongSelf.alpha = 1
                    }
                } else {
                    strongSelf.image = image
                }
            }
        }
    }
}

extension UIImage {
    /// Automatically detect and load the image from local or a remote url.
    public class func remoteOrLocalImage(_ source: ImageRepresentable, transform: ImageTransform? = nil, callback: @escaping (_ image: UIImage?) -> Void) {
        guard source.imageSource.isValid else {
            callback(nil)
            return
        }

        DispatchQueue.global(qos: .userInteractive).async {
            CompositeImageFetcher.fetch(source, in: nil) { image, _ in
                guard let image = image else {
                    DispatchQueue.main.async {
                        callback(nil)
                    }
                    return
                }

                DispatchQueue.global(qos: .userInteractive).async {
                    let image = image.process(source, using: transform)
                    DispatchQueue.main.async {
                        callback(image)
                    }
                }
            }
        }
    }

    /// Download multiple remote images.
    public class func downloadImages(_ urls: [String], callback: @escaping (_ images: [(url: URL, image: UIImage)]) -> Void) {
        guard !urls.isEmpty else { return }

        var orderedObjects: [(url: URL, image: UIImage?)] = urls.compactMap(URL.init).filter { $0.host != nil }.compactMap { ($0, nil) }
        var downloadedImages = 0

        orderedObjects.forEach { object in
            SDWebImageDownloader.shared().downloadImage(
                with: object.url,
                options: [],
                progress: { receivedSize, expectedSize, targetUrl in
                },
                completed: { image, data, error, finished in
                    downloadedImages += 1

                    if let image = image, finished {
                        if let index = (orderedObjects.index { $0.url == object.url }) {
                            orderedObjects[index].image = image
                        }
                    }

                    if downloadedImages == urls.count {
                        let imagesAndUrls = orderedObjects.filter { $0.image != nil }.compactMap { (url: $0.url, image: $0.image!) }
                        DispatchQueue.main.async {
                            callback(imagesAndUrls)
                        }
                    }
                }
            )
        }
    }
}

extension UIImage {
    /// Process the image using the given transform.
    ///
    /// - Parameters:
    ///   - source: The original source from which the image was constructed.
    ///   - transform: The transform to use.
    /// - Returns: The transformed image.
    fileprivate func process(_ source: ImageRepresentable, using transform: ImageTransform?) -> UIImage {
        guard let transform = transform else {
            return self
        }

        return transform.transform(self, source: source)
    }
}
