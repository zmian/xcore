//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in navigation controller.
    public func embedInNavigation() -> some View {
        NavigationView { self }
    }

    /// Wraps this view with a type eraser.
    ///
    /// - Returns: An `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

extension View {
    /// Positions this view within an invisible frame with the specified size.
    ///
    /// Use this method to specify a fixed size for a view's width, height, or
    /// both. If you only specify one of the dimensions, the resulting view
    /// assumes this view's sizing behavior in the other dimension.
    ///
    /// For example, the following code lays out an ellipse in a fixed 200 by
    /// 100 frame. Because a shape always occupies the space offered to it by
    /// the layout system, the first ellipse is 200x100 points. The second
    /// ellipse is laid out in a frame with only a fixed height, so it occupies
    /// that height, and whatever width the layout system offers to its parent.
    ///
    ///     VStack {
    ///         Ellipse()
    ///             .fill(Color.purple)
    ///             .frame(200)
    ///         Ellipse()
    ///             .fill(Color.blue)
    ///             .frame(100)
    ///     }
    ///
    /// ![A screenshot showing the effect of frame size options: a purple
    /// ellipse shows the effect of a fixed frame size, while a blue ellipse
    /// shows the effect of constraining a view in one
    /// dimension.](SwiftUI-View-frame-1.png)
    ///
    /// `The alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    ///     Text("Hello world!")
    ///         .frame(200, alignment: .topLeading)
    ///         .border(Color.gray)
    ///
    /// In the example above, the text is positioned at the top, leading corner
    /// of the frame. If the text is taller than the frame, its bounds may
    /// extend beyond the bottom of the frame's bounds.
    ///
    /// ![A screenshot showing the effect of frame size options on a text view
    /// showing a fixed frame size with a specified
    /// alignment.](SwiftUI-View-frame-2.png)
    ///
    /// - Parameters:
    ///   - size: A fixed width and height for the resulting view. If `size` is
    ///     `nil`, the resulting view assumes this view's sizing behavior.
    ///   - alignment: The alignment of this view inside the resulting view.
    ///     `alignment` applies if this view is smaller than the size given by
    ///     the resulting frame.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    public func frame(_ size: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}

// MARK: - On Tap

extension View {
    /// Returns a version of `self` that will perform `action` when `self` is
    /// triggered.
    public func onTap(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.scaleEffect)
    }
}

// MARK: - Colors

extension View {
    /// Sets the color that the view uses for foreground elements.
    public func foregroundColor(_ color: UIColor) -> some View {
        foregroundColor(Color(color))
    }

    /// Sets the background color behind this view.
    public func backgroundColor(_ color: UIColor, edgesIgnoringSafeArea: Edge.Set = .all) -> some View {
        background(
            Color(color)
                .edgesIgnoringSafeArea(edgesIgnoringSafeArea)
        )
    }
}

// MARK: - Hidden

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    /// ```
    /// Text("Label")
    ///     .hidden(true)
    /// ```
    ///
    /// Example for complete removal:
    ///
    /// ```
    /// Text("Label")
    ///     .hidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    public func hidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

// MARK: - Corner Radius

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

// MARK: - Border

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
    ///     - content: The border shape.
    ///     - width: The thickness of the border; if not provided, the default is
    ///       `1` pixel.
    ///     - color: The border color.
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
