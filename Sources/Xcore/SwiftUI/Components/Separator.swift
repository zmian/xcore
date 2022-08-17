//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    public func separator(hidden: Bool = false, alignment: Alignment = .bottom) -> some View {
        overlay(Separator().hidden(hidden), alignment: alignment)
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
    /// A line shape when contained in a stack, it extends across the minor axis of
    /// the stack, or horizontally when not in a stack.
    private struct SeparatorShape: Shape {
        let style: StrokeStyle

        func path(in rect: CGRect) -> Path {
            // Early exit for normal separator style
            // Note: we don't want to `strokedPath` for normal separator to avoid artifacts
            // which is visible when zoomed in.
            if style.lineWidth <= 1, style.dash.isEmpty {
                return Rectangle()
                    .path(in: rect)
            }

            return Path {
                let isHorizontal = rect.size.max == rect.width
                let capOffset = style.lineWidth / 2
                let origin = isHorizontal ? CGPoint(x: capOffset, y: 0) : CGPoint(x: 0, y: capOffset)

                if style.lineJoin == .round, isHorizontal || style.dash.isEmpty {
                    var rect = rect
                    rect.origin = origin

                    if isHorizontal {
                        rect.size.width -= style.lineWidth
                    } else {
                        rect.size.height -= style.lineWidth
                    }

                    $0.addPath(Path(rect))
                } else {
                    let end = isHorizontal ?
                        CGPoint(x: rect.width - capOffset, y: 0) :
                        CGPoint(x: 0, y: rect.height - capOffset)

                    $0.move(to: origin)
                    $0.addLine(to: end)
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
