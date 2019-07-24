//
// UIImageView+ImageRepresentable.swift
//
// Copyright © 2015 Xcore
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
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0,
    ///                        the image is set without animation. The default value is `.slow`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(
        _ image: ImageRepresentable?,
        alwaysAnimate: Bool = false,
        animationDuration: TimeInterval = .slow,
        _ callback: ((_ image: UIImage?) -> Void)? = nil
    ) {
        cancelSetImageRequest()

        guard let imageRepresentable = image, imageRepresentable.imageSource.isValid else {
            self.image = nil
            callback?(nil)
            return
        }

        UIImage.Fetcher.fetch(imageRepresentable, in: self) { [weak self] image, cacheType in
            guard let strongSelf = self else { return }
            let animated = (alwaysAnimate || cacheType.possiblyDelayed)
            strongSelf.postProcess(
                image: image,
                source: imageRepresentable,
                animationDuration: animated ? animationDuration : 0,
                callback
            )
        }
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image:             The image to display.
    ///   - defaultImage:      The fallback image to display if `image` can't be loaded.
    ///   - alwaysAnimate:     An option to always animate setting the image. The default value is `false`.
    ///                        The image will only fade in when fetched from a remote url and not in memory cache.
    ///   - animationDuration: The total duration of the animation. If the specified value is negative or 0,
    ///                        the image is set without animation. The default value is `.slow`.
    ///   - callback:          A block to invoke when finished setting the image.
    public func setImage(
        _ image: ImageRepresentable?,
        default defaultImage: ImageRepresentable,
        alwaysAnimate: Bool = false,
        animationDuration: TimeInterval = .slow,
        _ callback: ((_ image: UIImage?) -> Void)? = nil
    ) {
        guard let image = image else {
            setImage(
                defaultImage,
                alwaysAnimate: alwaysAnimate,
                animationDuration: animationDuration,
                callback
            )
            return
        }

        setImage(
            image,
            alwaysAnimate: alwaysAnimate,
            animationDuration: animationDuration
        ) { [weak self] image in
            guard let strongSelf = self else { return }

            guard image == nil else {
                callback?(image)
                return
            }

            strongSelf.setImage(
                defaultImage,
                alwaysAnimate: alwaysAnimate,
                animationDuration: animationDuration,
                callback
            )
        }
    }
}

extension UIImageView {
    private func postProcess(
        image: UIImage?,
        source: ImageRepresentable,
        animationDuration: TimeInterval,
        _ callback: ((_ image: UIImage?) -> Void)?
    ) {
        guard var image = image else {
            DispatchQueue.main.asyncSafe {
                callback?(nil)
            }
            return
        }

        // Ensure that we are not setting image to the incorrect image view
        // instance in case it's being reused (e.g., UICollectionViewCell).
        if let imageSource = imageRepresentableSource, imageSource != source.imageSource {
            return
        }

        guard let transform: ImageTransform = source.plugin() else {
            applyImage(image, animationDuration: animationDuration, callback)
            return
        }

        DispatchQueue.global(qos: .userInteractive).syncSafe { [weak self] in
            guard let strongSelf = self else { return }
            image = image.applying(transform, source: source)
            strongSelf.applyImage(image, animationDuration: animationDuration, callback)
        }
    }

    private func applyImage(
        _ image: UIImage,
        animationDuration: TimeInterval,
        _ callback: ((_ image: UIImage?) -> Void)?
    ) {
        DispatchQueue.main.asyncSafe { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setImage(image, animationDuration: animationDuration)
            callback?(image)
        }
    }
}
