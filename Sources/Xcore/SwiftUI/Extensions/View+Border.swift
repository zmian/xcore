//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds a border in front of this view with the specified shape, width and
    /// color.
    public func border(
        cornerRadius: CGFloat = AppConstants.cornerRadius,
        width: CGFloat = .onePixel,
        color: Color? = nil
    ) -> some View {
        border(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            width: width,
            color: color
        )
    }

    /// Adds a border in front of this view with the specified shape, width and
    /// color.
    ///
    /// Draws a border of a specified width around the view’s frame. By default, the
    /// border appears inside the bounds of this view.
    ///
    /// - Parameters:
    ///   - content: The border shape.
    ///   - width: The thickness of the border; if not provided, the default is
    ///     `1` pixel.
    ///   - color: The border color.
    /// - Returns: A view that adds a border with the specified shape, width and
    ///   color to this view.
    public func border<S>(_ content: S, width: CGFloat = .onePixel, color: Color? = nil) -> some View where S: InsettableShape {
        EnvironmentReader(\.theme) { theme in
            overlay(
                content
                    .strokeBorder(color ?? Color(theme.separatorColor), lineWidth: width)
            )
        }
    }
}
