//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Applies inverted mask to this view.
    ///
    /// Use this modifier to create a cut-out effect by inverting the alpha values
    /// of a masking view. Areas where the mask is opaque become transparent, and
    /// areas where the mask is transparent become opaque.
    ///
    /// For example, the following creates a view with a circular cut-out:
    ///
    /// ```swift
    /// Rectangle()
    ///     .invertedMask {
    ///         Circle()
    ///             .frame(200)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - alignment: The alignment for the mask relative to this view.
    ///   - mask: A view builder that produces the view to be used as the mask. The
    ///     alpha values of this view determine which areas of the view are
    ///     transparent.
    /// - Returns: A view that is masked using the inverse of the given mask.
    @inlinable
    nonisolated public func invertedMask(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> some View
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }

    /// Applies a mask overlay to this view.
    ///
    /// This modifier overlays the provided content onto this view using a
    /// source-atop blend mode. It draws the overlay only where this view already
    /// has content, ignoring any transparent pixels.
    ///
    /// Use this modifier when you want to apply an overlay (such as a gradient
    /// or image) that appears only atop the existing visible content of the view.
    ///
    /// ```swift
    /// Circle()
    ///     .fill(.indigo)
    ///     .maskOverlay {
    ///         LinearGradient(
    ///             colors: [.black, .white],
    ///             startPoint: .top,
    ///             endPoint: .bottom
    ///         )
    ///         .opacity(0.5)
    ///     }
    /// ```
    ///
    /// - Parameters:
    ///   - alignment: The alignment for the overlay relative to this view.
    ///   - content: A view builder that produces the overlay content.
    /// - Returns: A view that renders this view with the specified mask overlay
    ///   applied.
    @inlinable
    nonisolated public func maskOverlay(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> some View
    ) -> some View {
        overlay(alignment: alignment) {
            content()
                .blendMode(.sourceAtop)
        }
        .drawingGroup(opaque: false)
    }
}

// MARK: - Preview

#Preview("invertedMask") {
    Rectangle()
        .foregroundStyle(Color.black.opacity(0.75))
        .invertedMask {
            RoundedRectangle(cornerRadius: 30)
                .frame(100)
        }

    Rectangle()
        .invertedMask {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 200, height: 100)
        }

    Rectangle()
        .invertedMask(alignment: .trailing) {
            Circle()
                .frame(100)
        }

    Rectangle()
        .invertedMask(alignment: .leading) {
            Circle()
                .padding(5)
        }

    Rectangle()
        .invertedMask {
            HStack {
                RoundedRectangle(cornerRadius: 40)
                Circle()
                    .opacity(0.5)
            }
            .padding(5)
            .frame(width: 300)
        }
}

#Preview("maskOverlay") {
    Circle()
        .fill(.indigo)
        .maskOverlay {
            LinearGradient(
                colors: [.black, .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(0.5)
        }
}
