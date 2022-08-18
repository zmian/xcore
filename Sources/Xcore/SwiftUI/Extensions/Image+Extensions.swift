//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Image {
    /// Sets the mode by which SwiftUI resizes an image to fit its space.
    ///
    /// - Parameters:
    ///   - isActive: A Boolean value indicating whether the image is resizable.
    ///   - capInsets: Inset values that indicate a portion of the image that
    ///     SwiftUI doesn't resize.
    ///   - resizingMode: The mode by which SwiftUI resizes the image.
    /// - Returns: An image, with the new resizing behavior set.
    public func resizable(
        _ isActive: Bool,
        capInsets: EdgeInsets = .zero,
        resizingMode: ResizingMode = .stretch
    ) -> Image {
        isActive ? resizable(capInsets: capInsets, resizingMode: resizingMode) : self
    }
}
