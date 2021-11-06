//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Invertly masks this view using the given size and corner radius.
    ///
    /// ```
    /// Rectangle()
    ///     .maskInvert(size: 200, cornerRadius: 30)
    ///     .ignoresSafeArea()
    /// ```
    public func maskInvert(size: CGFloat, cornerRadius: CGFloat) -> some View {
        maskInvert(size: CGSize(size), cornerRadius: cornerRadius)
    }

    /// Invertly masks this view using the given size and corner radius.
    ///
    /// ```
    /// Rectangle()
    ///     .maskInvert(size: CGSize(width: 200, height: 100), cornerRadius: 30)
    ///     .ignoresSafeArea()
    /// ```
    public func maskInvert(size: CGSize, cornerRadius: CGFloat) -> some View {
        foregroundColor(Color.black.opacity(0.75))
            .maskInvert(
                RoundedRectangleCorner(radius: cornerRadius, corners: .allCorners),
                size: size
            )
    }

    /// Invertly masks this view using the given size and corner radius.
    ///
    /// ```
    /// Rectangle()
    ///     .maskInvert(Circle(), size: CGSize(width: 200, height: 100))
    ///     .ignoresSafeArea()
    /// ```
    public func maskInvert<S: Shape>(_ shape: S, size: CGSize) -> some View {
        mask(
            InvertedShape(shape, size: size)
                .fill(style: FillStyle(eoFill: true))
        )
    }

    /// Invertly masks this view using the given size and corner radius.
    ///
    /// ```
    /// Rectangle()
    ///     .maskInvert(Circle(), lineWidth: 20)
    ///     .ignoresSafeArea()
    /// ```
    public func maskInvert<S: Shape>(_ shape: S, lineWidth: CGFloat) -> some View {
        mask(
            InvertedShape(shape, lineWidth: lineWidth)
                .fill(style: FillStyle(eoFill: true))
        )
    }
}

// MARK: - InvertedShape

private struct InvertedShape<S: Shape>: Shape {
    private let dimension: Either<CGSize, CGFloat>
    private let shape: S

    init(_ shape: S, size: CGSize) {
        self.shape = shape
        self.dimension = .left(size)
    }

    init(_ shape: S, lineWidth: CGFloat) {
        self.shape = shape
        self.dimension = .right(lineWidth)
    }

    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)

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

        path.addPath(shape.path(in: innerRect))

        return path
    }
}
