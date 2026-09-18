//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UIImageView {
    /// Automatically detects and loads the image from a local or remote URL.
    ///
    /// Image transforms execute off the main actor. Image assignment and the
    /// completion callback execute on the main actor.
    ///
    /// - Parameters:
    ///   - image: The image to be displayed.
    ///   - animationDuration: The total duration of the animation. If the specified
    ///     value is negative or `0`, the image is set without animation; otherwise,
    ///     the image will only fade in when fetched from a remote URL and not in
    ///     memory cache.
    ///   - callback: A closure to be invoked when finished setting the image. The
    ///     closure receives the loaded image, or `nil` on failure. Cancelled or
    ///     superseded requests do not call the closure.
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

        let requestID = UUID()
        imageSetRequestID = requestID

        imageSetTask = Task { @MainActor in
            guard imageSetRequestID == requestID else { return }
            defer {
                if imageSetRequestID == requestID {
                    imageSetTask = nil
                }
            }

            do {
                var (image, cacheType) = try await UIImage.Fetcher.fetch(imageRepresentable, in: self)
                guard imageSetRequestID == requestID else { return }
                try Task.checkCancellation()

                if let transform: ImageTransform = imageRepresentable.plugin() {
                    image = try await applyingImageTransform(transform, to: image, source: imageRepresentable)
                }

                guard imageSetRequestID == requestID else { return }
                try Task.checkCancellation()

                setUIImage(image, animationDuration: cacheType.possiblyDelayed ? animationDuration : 0)
                callback?(image)
            } catch is CancellationError {
                // A cancelled request must not trigger a fallback image.
            } catch {
                guard imageSetRequestID == requestID, !Task.isCancelled else { return }
                self.image = nil
                callback?(nil)
            }
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
    ///     closure receives the loaded image, or `nil` on failure. Cancelled or
    ///     superseded requests do not call the closure.
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

// Keeps synchronous image processing on the concurrent executor while retaining
// the loading task's cancellation state and task-local values.
@concurrent
private func applyingImageTransform(
    _ transform: ImageTransform,
    to image: UIImage,
    source: ImageRepresentable
) async throws -> UIImage {
    try Task.checkCancellation()
    let result = image.applying(transform, source: source)
    try Task.checkCancellation()
    return result
}
#endif
