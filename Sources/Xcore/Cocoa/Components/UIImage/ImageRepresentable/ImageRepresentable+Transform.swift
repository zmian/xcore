//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension ImageRepresentable {
    /// Returns an `ImageRepresentable` instance with the given transform.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// func setIcon(_ icon: ImageRepresentable) {
    ///     let newIcon = icon
    ///         .alignment(.leading)
    ///         .transform(.tintColor(.white))
    ///         .alignment(.trailing) // The last one wins when using plugins.
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
        append(value)
    }
}
