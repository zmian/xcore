//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIImageView {
    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image: The image to display.
    ///   - alwaysAnimate: An option to always animate setting the image. The image
    ///     will only fade in when fetched from a remote url and not in memory
    ///     cache.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation.
    ///   - callback: A closure to invoke when finished setting the image.
    public func setImage(
        _ image: ImageRepresentable?,
        alwaysAnimate: Bool = false,
        animationDuration: TimeInterval = .slow,
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

        UIImage.Fetcher.fetch(imageRepresentable, in: self) { [weak self] result in
            guard let strongSelf = self else { return }
            let result = try? result.get()
            let animated = alwaysAnimate || (result?.cacheType ?? .none).possiblyDelayed
            strongSelf.postProcess(
                image: result?.image,
                source: imageRepresentable,
                animationDuration: animated ? animationDuration : 0,
                callback
            )
        }
    }

    /// Automatically detect and load the image from local or a remote url.
    ///
    /// - Parameters:
    ///   - image: The image to display.
    ///   - defaultImage: The fallback image to display if `image` can't be loaded.
    ///   - alwaysAnimate: An option to always animate setting the image. The image
    ///     will only fade in when fetched from a remote url and not in memory
    ///     cache.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation.
    ///   - callback: A closure to invoke when finished setting the image.
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

        // Ensure that we are not setting image to the incorrect image view instance in
        // case it's being reused (e.g., `UICollectionViewCell`).
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
