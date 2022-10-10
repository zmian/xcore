//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension InsettableShape {
    /// Trims this shape by a fractional amount based on its representation as a
    /// path.
    ///
    /// To create a `Shape` instance, you define the shape's path using lines and
    /// curves. Use the `trim(from:to:)` method to draw a portion of a shape by
    /// ignoring portions of the beginning and ending of the shape's path.
    ///
    /// For example, if you're drawing a figure eight or infinity symbol (∞)
    /// starting from its center, setting the `startFraction` and `endFraction`
    /// to different values determines the parts of the overall shape.
    ///
    /// The following example shows a simplified infinity symbol that draws only
    /// three quarters of the full shape. That is, of the two lobes of the symbol,
    /// one lobe is complete and the other is half complete.
    ///
    /// ```swift
    /// Path { path in
    ///     path.addLines([
    ///         .init(x: 2, y: 1),
    ///         .init(x: 1, y: 0),
    ///         .init(x: 0, y: 1),
    ///         .init(x: 1, y: 2),
    ///         .init(x: 3, y: 0),
    ///         .init(x: 4, y: 1),
    ///         .init(x: 3, y: 2),
    ///         .init(x: 2, y: 1)
    ///     ])
    /// }
    /// .trim(from: 0.25, to: 1.0)
    /// .scale(50, anchor: .topLeading)
    /// .stroke(Color.black, lineWidth: 3)
    /// ```
    ///
    /// Changing the parameters of `trim(from:to:)` to
    /// `.trim(from: 0, to: 1)` draws the full infinity symbol, while
    /// `.trim(from: 0, to: 0.5)` draws only the left lobe of the symbol.
    ///
    /// - Parameters:
    ///   - startFraction: The fraction of the way through drawing this shape
    ///     where drawing starts.
    ///   - endFraction: The fraction of the way through drawing this shape
    ///     where drawing ends.
    /// - Returns: A shape built by capturing a portion of this shape's path.
    @_disfavoredOverload
    public func trim(from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) -> some InsettableShape {
        TrimmedShape(shape: self, from: startFraction, to: endFraction)
    }
}

// MARK: - TrimmedShape

/// A shape with a trim effect applied to it and conditionally preserving
/// `InsettableShape` conformance of the underlying shape.
private struct TrimmedShape<Content>: Shape where Content: Shape {
    private let startFraction: CGFloat
    private let endFraction: CGFloat
    private var shape: Content

    /// Creates a trimmed shape.
    ///
    /// - Parameters:
    ///   - shape: The shape to trim.
    ///   - startFraction: The fraction of the way through drawing this shape
    ///     where drawing starts.
    ///   - endFraction: The fraction of the way through drawing this shape
    ///     where drawing ends.
    init(shape: Content, from startFraction: CGFloat = 0, to endFraction: CGFloat = 1) {
        self.shape = shape
        self.startFraction = startFraction
        self.endFraction = endFraction
    }

    func path(in rect: CGRect) -> Path {
        shape
            .trim(from: startFraction, to: endFraction)
            .path(in: rect)
    }
}

extension TrimmedShape: InsettableShape where Content: InsettableShape {
    /// Returns `self` inset by `amount`.
    func inset(by amount: CGFloat) -> TrimmedShape<Content.InsetShape> {
        TrimmedShape<Content.InsetShape>(
            shape: shape.inset(by: amount),
            from: startFraction,
            to: endFraction
        )
    }
}

extension TrimmedShape: Sendable where Content: Sendable {}
