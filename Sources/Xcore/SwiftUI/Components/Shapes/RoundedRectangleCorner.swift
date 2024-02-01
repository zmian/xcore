//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A rectangular shape with rounded corners, aligned inside the frame of the
/// view containing it.
public struct RoundedRectangleCorner: Shape, Sendable {
    private let radius: CGFloat
    private let corners: UIRectCorner

    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        RoundedRectangleCorner(radius: 75, corners: [.topLeft, .bottomRight])
            .fill(.blue)
        RoundedRectangleCorner(radius: 75, corners: .top)
            .fill(.orange)
        RoundedRectangleCorner(radius: 75, corners: .bottom)
            .fill(.green)
    }
    .frame(150)
}
