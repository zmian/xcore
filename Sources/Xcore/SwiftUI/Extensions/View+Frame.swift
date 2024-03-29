//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

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
    /// ```swift
    /// VStack {
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .frame(200)
    ///     Ellipse()
    ///         .fill(Color.blue)
    ///         .frame(100)
    /// }
    /// ```
    ///
    /// ![A screenshot showing the effect of frame size options: a purple
    /// ellipse shows the effect of a fixed frame size, while a blue ellipse
    /// shows the effect of constraining a view in one
    /// dimension.](SwiftUI-View-frame-1.png)
    ///
    /// `The alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    /// ```swift
    /// Text("Hello world!")
    ///     .frame(200, alignment: .topLeading)
    ///     .border(Color.gray)
    /// ```
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
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    public func frame(_ size: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }

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
    /// ```swift
    /// let size = CGSize(width: 200, height: 100)
    ///
    /// VStack {
    ///     Ellipse()
    ///         .fill(Color.purple)
    ///         .frame(size)
    ///     Ellipse()
    ///         .fill(Color.blue)
    ///         .frame(100)
    /// }
    /// ```
    ///
    /// ![A screenshot showing the effect of frame size options: a purple
    /// ellipse shows the effect of a fixed frame size, while a blue ellipse
    /// shows the effect of constraining a view in one
    /// dimension.](SwiftUI-View-frame-1.png)
    ///
    /// `The alignment` parameter specifies this view's alignment within the
    /// frame.
    ///
    /// ```swift
    /// let size = CGSize(width: 200, height: 100)
    ///
    /// Text("Hello world!")
    ///     .frame(size, alignment: .topLeading)
    ///     .border(Color.gray)
    /// ```
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
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    public func frame(_ size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(width: size?.width, height: size?.height, alignment: alignment)
    }

    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    ///
    /// If no maximum constraint is specified, the frame adopts the sizing behavior
    /// of its child. If a maximum constraint is specified and the size proposed for
    /// the frame by the parent is greater than the size of this view, the proposed
    /// size, clamped to that maximum.
    ///
    /// - Parameters:
    ///   - max: The maximum width and height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame. Note
    ///     that most alignment values have no apparent effect when the size of the
    ///     frame happens to match that of this view.
    ///
    /// - Returns: A view with flexible dimensions given by the call's non-`nil`
    ///   parameters.
    public func frame(max: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(maxWidth: max, maxHeight: max, alignment: alignment)
    }

    /// Positions this view within an invisible frame having the specified size
    /// constraints.
    ///
    /// If no minimum constraint is specified, the frame adopts the sizing behavior
    /// of its child. If a minimum constraint is specified and the size proposed for
    /// the frame by the parent is less than the size of this view, the proposed
    /// size, clamped to that minimum.
    ///
    /// - Parameters:
    ///   - min: The minimum width and height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with flexible dimensions given by the call's non-`nil`
    ///   parameters.
    public func frame(min: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(minWidth: min, minHeight: min, alignment: alignment)
    }
}
