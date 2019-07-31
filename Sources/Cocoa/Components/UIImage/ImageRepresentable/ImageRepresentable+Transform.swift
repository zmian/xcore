//
// ImageRepresentable+Transform.swift
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

extension ImageRepresentable {
    /// Returns `ImageRepresentable` instance with the given transform.
    ///
    /// **Usage**:
    ///
    /// ```swift
    /// func setIcon(_ icon: ImageRepresentable) {
    ///     let newIcon = icon
    ///         .alignment(.leading)
    ///         .transform(TintColorImageTransform(tintColor: .white))
    ///         .alignment(.trailing) // last one wins when using plugin.
    ///
    ///     let iconView = UIImageView()
    ///     iconView.setImage(newIcon)
    ///
    ///     let transform: ImageTransform = newIcon.plugin()!
    ///     print(transform.id)
    ///     // "TintColorImageTransform-tintColor:(#FFFFFF)"
    ///
    ///     let alignment: ImageRepresentableAlignment = newIcon.plugin()!
    ///     print(alignment)
    ///     // "trailing"
    /// }
    /// ```
    ///
    /// - Parameter value: The transform value for the image.
    /// - Returns: An `ImageRepresentable` instance.
    public func transform(_ value: ImageTransform) -> ImageRepresentable {
        return append(value)
    }

    /// Returns `ImageRepresentable` instance with the given transform.
    ///
    /// **Usage**:
    ///
    /// ```swift
    /// func setIcon(_ icon: ImageRepresentable) {
    ///     let newIcon = icon
    ///         .alignment(.leading)
    ///         .transform(.tintColor(.white))
    ///         .alignment(.trailing) // last one wins when using plugin.
    ///
    ///     let iconView = UIImageView()
    ///     iconView.setImage(newIcon)
    ///
    ///     let transform: ImageTransform = newIcon.plugin()!
    ///     print(transform.id)
    ///     // "TintColorImageTransform-tintColor:(#FFFFFF)"
    ///
    ///     let alignment: ImageRepresentableAlignment = newIcon.plugin()!
    ///     print(alignment)
    ///     // "trailing"
    /// }
    /// ```
    ///
    /// - Parameter transform: The transform for the image.
    /// - Returns: An `ImageRepresentable` instance.
    public func transform<T: ImageTransform>(_ transform: T.Member) -> ImageRepresentable {
        return append(transform.base)
    }
}
