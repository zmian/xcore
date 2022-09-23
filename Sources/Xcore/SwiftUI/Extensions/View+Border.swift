//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds a border in front of this view with the specified corner radius, width
    /// and color.
    ///
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the border.
    ///   - lineWidth: The thickness of the border. The default is 1 pixel.
    ///   - color: The border color.
    /// - Returns: A view that adds a border with the specified corner radius, width
    ///   and color to this view.
    public func border(
        cornerRadius: CGFloat = AppConstants.cornerRadius,
        lineWidth: CGFloat = .onePixel,
        color: Color? = nil
    ) -> some View {
        border(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous),
            lineWidth: lineWidth,
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
    ///   - lineWidth: The thickness of the border. The default is 1 pixel.
    ///   - color: The border color.
    /// - Returns: A view that adds a border with the specified shape, width and
    ///   color to this view.
    public func border(
        _ content: some InsettableShape,
        lineWidth: CGFloat = .onePixel,
        color: Color? = nil
    ) -> some View {
        EnvironmentReader(\.theme) { theme in
            overlay(
                content
                    .strokeBorder(color ?? theme.separatorColor, lineWidth: lineWidth)
            )
        }
    }
}
