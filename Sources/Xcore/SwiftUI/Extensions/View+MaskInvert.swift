//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Applies an inverted mask to this view, revealing content outside the
    /// specified bounds.
    ///
    /// This method creates a cut-out effect by masking everything except the
    /// specified area.
    ///
    /// ```swift
    /// Rectangle()
    ///     .maskInvert(size: 200, cornerRadius: 30)
    ///     .ignoresSafeArea()
    /// ```
    ///
    /// - Parameters:
    ///   - size: The width and height of the unmasked area.
    ///   - cornerRadius: The corner radius to apply to the rectangular mask.
    /// - Returns: A view with an inverted mask applied using the rectangular shape.
    public func maskInvert(size: CGFloat, cornerRadius: CGFloat) -> some View {
        maskInvert(size: CGSize(size), cornerRadius: cornerRadius)
    }

    /// Applies an inverted mask to this view, revealing content outside the
    /// specified bounds.
    ///
    /// This method creates a cut-out effect by masking everything except the
    /// specified area.
    ///
    /// ```swift
    /// Rectangle()
    ///     .maskInvert(size: CGSize(width: 200, height: 100), cornerRadius: 30)
    ///     .ignoresSafeArea()
    /// ```
    ///
    /// - Parameters:
    ///   - size: The dimensions of the unmasked area.
    ///   - cornerRadius: The corner radius to apply to the rectangular mask.
    /// - Returns: A view with an inverted mask applied using the rectangular shape.
    public func maskInvert(size: CGSize, cornerRadius: CGFloat) -> some View {
        foregroundStyle(Color.black.opacity(0.75))
            .maskInvert(.rect(cornerRadius: cornerRadius), size: size)
    }

    /// Applies an inverted mask to this view using a specified shape.
    ///
    /// This method creates a cut-out effect by masking everything except the
    /// specified shape.
    ///
    /// ```swift
    /// Rectangle()
    ///     .maskInvert(.circle, size: CGSize(width: 200, height: 100))
    ///     .ignoresSafeArea()
    /// ```
    ///
    /// - Parameters:
    ///   - shape: The shape used to define the unmasked area.
    ///   - size: The dimensions of the shape.
    /// - Returns: A view with an inverted mask applied using the specified shape.
    public func maskInvert<S: Shape>(_ shape: S, size: CGSize) -> some View {
        mask(
            InvertedShape(shape, size: size)
                .fill(style: FillStyle(eoFill: true))
        )
    }

    /// Applies an inverted mask to this view using a shape with a specified line
    /// width.
    ///
    /// This method creates a cut-out effect by masking everything except the
    /// specified shape.
    ///
    /// ```swift
    /// Rectangle()
    ///     .maskInvert(.circle, lineWidth: 20)
    ///     .ignoresSafeArea()
    /// ```
    ///
    /// - Parameters:
    ///   - shape: The shape used to define the unmasked area.
    ///   - lineWidth: The thickness of the shape outline that remains unmasked.
    /// - Returns: A view with an inverted mask applied using the specified shape
    ///  and line width.
    public func maskInvert<S: Shape>(_ shape: S, lineWidth: CGFloat) -> some View {
        mask(
            InvertedShape(shape, lineWidth: lineWidth)
                .fill(style: FillStyle(eoFill: true))
        )
    }
}

// MARK: - InvertedShape

/// A shape that inverts its masking effect, allowing only the specified shape
/// region to be visible.
private struct InvertedShape<S: Shape>: Shape {
    private let dimension: Either<CGSize, CGFloat>
    private let shape: S

    /// Initializes an `InvertedShape` with a specified shape and size.
    ///
    /// - Parameters:
    ///   - shape: The shape used to define the unmasked area.
    ///   - size: The dimensions of the shape.
    init(_ shape: S, size: CGSize) {
        self.shape = shape
        self.dimension = .left(size)
    }

    /// Initializes an `InvertedShape` with a specified shape and line width.
    ///
    /// - Parameters:
    ///   - shape: The shape used to define the unmasked area.
    ///   - lineWidth: The thickness of the unmasked shape outline.
    init(_ shape: S, lineWidth: CGFloat) {
        self.shape = shape
        self.dimension = .right(lineWidth)
    }

    /// Generates the path for the inverted shape, ensuring only the shape area
    /// remains visible.
    ///
    /// - Parameter rect: The frame in which the shape is drawn.
    /// - Returns: A `Path` object representing the masked and unmasked areas.
    func path(in rect: CGRect) -> Path {
        let innerRect: CGRect

        switch dimension {
            case let .left(size):
                let origin = CGPoint(
                    x: rect.midX - size.width / 2,
                    y: rect.midY - size.height / 2
                )
                innerRect = CGRect(origin: origin, size: size)
            case let .right(lineWidth):
                innerRect = rect.inset(by: .init(lineWidth))
        }

        var path = Rectangle().path(in: rect)
        path.addPath(shape.path(in: innerRect))
        return path
    }
}

// MARK: - Preview

#Preview {
    Rectangle()
        .maskInvert(size: 100, cornerRadius: 30)

    Rectangle()
        .maskInvert(size: CGSize(width: 200, height: 100), cornerRadius: 30)

    Rectangle()
        .maskInvert(.circle, size: CGSize(100))

    Rectangle()
        .maskInvert(.circle, lineWidth: 5)
}
