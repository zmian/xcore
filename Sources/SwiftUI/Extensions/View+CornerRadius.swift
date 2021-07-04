//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Clips the view to its bounding frame, with the specified corner radius.
    ///
    /// By default, a view’s bounding frame only affects its layout, so any content
    /// that extends beyond the edges of the frame remains visible. Use the
    /// `cornerRadius(_:corners:)` modifier to hide any content that extends beyond
    /// these edges while applying a corner radius.
    ///
    /// The following code applies a corner radius of 20 to a square image to top
    /// edges only:
    ///
    /// ```swift
    /// Image("walnuts")
    ///     .cornerRadius(20, corners: .top)
    /// ```
    ///
    /// - Parameters:
    ///   - radius: The corner radius.
    ///   - corners: The corners to apply the radius.
    /// - Returns: A view that clips this view to its bounding frame.
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Shape

private struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(radius)
        )
        return Path(path.cgPath)
    }
}
