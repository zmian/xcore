//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Clips this view to its bounding frame, with the specified corner radius.
    ///
    /// By default, a view's bounding frame only affects its layout, so any content
    /// that extends beyond the edges of the frame remains visible. Use
    /// `cornerRadius(_:style:)` to hide any content that extends beyond these edges
    /// while applying a corner radius.
    ///
    /// The following code applies a corner radius of 25 to a text view:
    ///
    /// ```swift
    /// Text("Rounded Corners")
    ///     .frame(width: 175, height: 75)
    ///     .foregroundStyle(Color.white)
    ///     .background(Color.black)
    ///     .cornerRadius(25, style: .continuous)
    /// ```
    ///
    /// ![A screenshot of a rectangle with rounded corners bounding a text
    /// view.](SwiftUI-View-cornerRadius.png)
    ///
    /// - Parameter radius: The corner radius.
    /// - Returns: A view that clips this view to its bounding frame with the
    ///   specified corner radius.
    public func cornerRadius(_ radius: CGFloat, style: RoundedCornerStyle) -> some View {
        clipShape(.rect(cornerRadius: radius, style: style))
    }
}
