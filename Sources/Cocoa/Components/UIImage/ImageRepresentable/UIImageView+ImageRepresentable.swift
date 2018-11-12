//
// UIImageView+ImageRepresentable.swift
//
// Copyright © 2015 Zeeshan Mian
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

extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - transform:         An optional property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, transform: ImageTransform? = nil, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
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

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - transform:         An optional property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, default defaultImage: ImageRepresentable, transform: ImageTransform? = nil, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        guard let image = image else {
            setImage(defaultImage, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
            return
        }

        setImage(image, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration) { [weak self] image in
            guard let strongSelf = self else { return }

            guard image == nil else {
                callback?(image)
                return
            }

            strongSelf.setImage(defaultImage, transform: transform, alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
        }
    }
}

// Added an extension to expose `ImageTransformers`.

extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - transform:         A property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, transform: ImageTransformer, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        setImage(image, transform: transform.transform(), alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - transform:         A property to transform the image before setting the image.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0, the image is set without animation. The default value is `0.5`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(_ image: ImageRepresentable?, default defaultImage: ImageRepresentable, transform: ImageTransformer, alwaysAnimate: Bool = false, animationDuration: TimeInterval = .slow, callback: ((_ image: UIImage?) -> Void)? = nil) {
        setImage(image, default: defaultImage, transform: transform.transform(), alwaysAnimate: alwaysAnimate, animationDuration: animationDuration, callback: callback)
    }
}

extension UIImageView {
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
