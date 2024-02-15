//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImageView {
    /// Automatically detects and loads the image from a local or remote URL.
    ///
    /// - Parameters:
    ///   - image: The image to be displayed.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation; otherwise,
    ///     the image will only fade in when fetched from a remote URL and not in
    ///     memory cache.
    ///   - callback: A closure to be invoked when finished setting the image. The
    ///     closure receives the `UIImage` object as its parameter.
    public func setImage(
        _ image: ImageRepresentable?,
        duration animationDuration: TimeInterval = .default,
        _ callback: ((_ image: UIImage?) -> Void)? = nil
    ) {
        cancelSetImageRequest()

        guard
            let imageRepresentable = image,
            imageRepresentable.imageSource.isValid
        else {
            self.image = nil
            callback?(nil)
            return
        }

        Task { @MainActor in
            var (image, cacheType) = try await UIImage.Fetcher.fetch(imageRepresentable, in: self)
            let animated = cacheType.possiblyDelayed

            // Ensure that we are not setting image to the incorrect image view instance in
            // case it's being reused (e.g., `UICollectionViewCell`).
            if let imageRepresentableSource, imageRepresentableSource != imageRepresentable.imageSource {
                return
            }

            if let transform: ImageTransform = imageRepresentable.plugin() {
                image = await Task { [image] in
                    image.applying(transform, source: imageRepresentable)
                }.value
            }

            setUIImage(image, animationDuration: animated ? animationDuration : 0)
            callback?(image)
        }
    }

    /// Automatically detects and loads the image from a local or remote URL.
    ///
    /// - Parameters:
    ///   - image: The image to be displayed.
    ///   - defaultImage: The fallback image to display if `image` can't be loaded.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation; otherwise,
    ///     the image will only fade in when fetched from a remote URL and not in
    ///     memory cache.
    ///   - callback: A closure to be invoked when finished setting the image. The
    ///     closure receives the `UIImage` object as its parameter.
    public func setImage(
        _ image: ImageRepresentable?,
        default defaultImage: ImageRepresentable,
        duration animationDuration: TimeInterval = .default,
        _ callback: ((_ image: UIImage?) -> Void)? = nil
    ) {
        guard let image else {
            setImage(defaultImage, duration: animationDuration, callback)
            return
        }

        setImage(image, duration: animationDuration) { [weak self] image in
            guard let self else { return }

            guard image == nil else {
                callback?(image)
                return
            }

            setImage(defaultImage, duration: animationDuration, callback)
        }
    }
}
