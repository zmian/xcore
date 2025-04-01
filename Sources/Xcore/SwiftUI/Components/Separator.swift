//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds a separator to this view with the specified alignment.
    public func separator(hidden: Bool = false, alignment: Alignment = .bottom) -> some View {
        overlay(alignment: alignment) {
            Separator().hidden(hidden)
        }
    }
}

/// A visual element that can be used to separate other content.
///
/// When contained in a stack, the separator extends across the minor axis of
/// the stack, or horizontally when not in a stack.
///
/// Similar to `Divider` but allows the user to customize the stroke style of
/// the separator.
public struct Separator: View {
    @Environment(\.theme) private var theme
    private let color: Color?
    private let style: StrokeStyle

    /// Creates a new separator from the given color and stroke style.
    ///
    /// - Parameters:
    ///   - color: The foreground color of the separator.
    ///   - style: The stroke style of the separator.
    public init(color: Color? = nil, style: StrokeStyle) {
        self.color = color
        self.style = style
    }

    /// Creates a new separator from the given color and stroke style.
    ///
    /// - Parameters:
    ///   - color: The foreground color of the separator.
    ///   - lineWidth: The thickness of the separator.
    public init(color: Color? = nil, lineWidth: CGFloat = .onePixel) {
        self.init(color: color, style: .init(lineWidth: lineWidth, lineJoin: .round))
    }

    public var body: some View {
        Divider()
            .hidden()
            .overlay(
                SeparatorShape(style: style)
                    .fill(color ?? theme.separatorColor)
            )
            .accessibilityHidden(true)
    }
}

// MARK: - Shape

extension Separator {
    /// A shape that renders a separator line based on a given stroke style.
    ///
    /// When used in a stack, the separator extends along the minor axis of the
    /// container, or horizontally when not in a stack.
    private struct SeparatorShape: Shape {
        /// The stroke style used to draw the separator.
        let style: StrokeStyle

        /// Generates a path for the separator in the given rectangle.
        ///
        /// If the line width is 1 or less and there is no dash pattern, a simple
        /// rectangle is returned to avoid zoom artifacts. Otherwise, the path is
        /// constructed based on whether the separator is horizontal or vertical.
        ///
        /// - Parameter rect: The drawing rectangle.
        /// - Returns: A stroked path for the separator.
        func path(in rect: CGRect) -> Path {
            // If the stroke is simple, return a rectangle path.
            //
            // Note: we don't want to `strokedPath` for normal separator to avoid artifacts
            // which is visible when zoomed in.
            if style.lineWidth <= 1, style.dash.isEmpty {
                return Rectangle().path(in: rect)
            }

            return Path { path in
                // Determine if the separator is horizontal.
                let isHorizontal = rect.size.max == rect.width
                let capOffset = style.lineWidth / 2
                let origin = isHorizontal
                    ? CGPoint(x: capOffset, y: 0)
                    : CGPoint(x: 0, y: capOffset)

                // If the line join is round and the separator is horizontal or has
                // no dash pattern, adjust the drawing rectangle.
                if style.lineJoin == .round, isHorizontal || style.dash.isEmpty {
                    var rect = rect
                    rect.origin = origin

                    if isHorizontal {
                        rect.size.width -= style.lineWidth
                    } else {
                        rect.size.height -= style.lineWidth
                    }
                    path.addPath(Path(rect))
                } else {
                    // Otherwise, draw a straight line from the origin to the end point.
                    let end = isHorizontal
                        ? CGPoint(x: rect.width - capOffset, y: 0)
                        : CGPoint(x: 0, y: rect.height - capOffset)

                    path.move(to: origin)
                    path.addLine(to: end)
                }
            }
            .strokedPath(style)
        }
    }
}

// MARK: - Helpers

extension StrokeStyle {
    /// Creates a new dotted stroke style with the line width of `2`.
    public static var dotted: Self {
        dotted(lineWidth: 2)
    }

    /// Creates a new dotted stroke style with the given width.
    public static func dotted(lineWidth: CGFloat) -> Self {
        let dash = lineWidth == 2 ? 8 : lineWidth * 2

        return .init(
            lineWidth: lineWidth,
            lineCap: .round,
            lineJoin: .round,
            dash: [0.001, dash]
        )
    }
}
