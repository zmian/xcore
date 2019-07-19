//
// TransformableImage.swift
//
// Copyright © 2019 Xcore
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

/// A wrapper type to encode transform information for any `ImageRepresentable`
/// type.
public struct TransformableImage: ImageRepresentable {
    private let image: ImageRepresentable
    public let transform: ImageTransform

    public var imageSource: ImageSourceType {
        return image.imageSource
    }

    public var bundle: Bundle? {
        return image.bundle
    }

    public init(_ image: ImageRepresentable, transform: ImageTransform) {
        self.image = image
        self.transform = transform
    }
}

// MARK: - ImageRepresentable

extension ImageRepresentable {
    /// Returns `TransformableImage` instance with the given transform.
    ///
    /// **Usage**:
    ///
    /// ```swift
    /// func setIcon(_ icon: ImageRepresentable) {
    ///     let newIcon = icon
    ///         .alignment(.leading)
    ///         .transform(.tintColor(.white))
    ///         .alignment(.trailing) // last one wins
    ///
    ///     let iconView = UIImageView()
    ///     iconView.setImage(newIcon)
    /// }
    /// ```
    ///
    /// - Parameter value: The transform value for the image.
    /// - Returns: A `TransformableImage` instance.
    public func transform(_ value: ImageTransform) -> TransformableImage {
        return TransformableImage(self, transform: value)
    }

    /// Returns `TransformableImage` instance with the given transform.
    ///
    /// **Usage**:
    ///
    /// ```swift
    /// func setIcon(_ icon: ImageRepresentable) {
    ///     let newIcon = icon
    ///         .alignment(.leading)
    ///         .transform(.tintColor(.white))
    ///         .alignment(.trailing) // last one wins
    ///
    ///     let iconView = UIImageView()
    ///     iconView.setImage(newIcon)
    /// }
    /// ```
    ///
    /// - Parameter transform: The transform for the image.
    /// - Returns: A `TransformableImage` instance.
    public func transform<T: ImageTransform>(_ transform: T.Member) -> TransformableImage {
        return TransformableImage(self, transform: transform.base)
    }
}
