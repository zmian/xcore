//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view that aligns content selectively to the leading, center,
/// or trailing edges based on a percentage.
///
/// It horizontally positions content by specifying a percentage (0...1). The
/// `preserveBounds` parameter provides control over whether the content extends
/// beyond the edges or is confined to either the leading or trailing edge of
/// the container.
public struct BoundedView<Content: View>: View {
    private let percent: Double
    private let preserveBounds: Bool
    private let content: Content

    /// A container view that aligns content selectively to the leading, center,
    /// or trailing edges based on a percentage (0...1).
    ///
    /// - Parameters:
    ///   - percent: A value indicating the horizontal alignment as a percentage
    ///     (0...1).
    ///   - preserveBounds: A boolean determining whether the content should extend
    ///     beyond the bounds or be confined.
    ///   - content: The content to be bounded.
    public init(
        percent: Double,
        preserveBounds: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.percent = percent
        self.preserveBounds = preserveBounds
        self.content = content()
    }

    public var body: some View {
        BoundedLayout(percent: percent, preserveBounds: preserveBounds) {
            content
        }
    }
}

/// A custom layout that positions content based on a percentage (0...1),
/// allowing alignment to the leading, center, or trailing edges.
///
/// The `preserveBounds` parameter controls whether the content extends beyond
/// the edges or is confined to the bounds of the container.
private struct BoundedLayout: Layout {
    let percent: Double
    let preserveBounds: Bool

    /// Calculates the size required to fit all subviews.
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let contentSize = subviews.first?.sizeThatFits(proposal) else {
            return .zero
        }

        return CGSize(width: proposal.width ?? contentSize.width, height: contentSize.height)
    }

    /// Places the subviews based on the provided `percent` and alignment rules.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard let subview = subviews.first else { return }

        // Determine the width of the content.
        let contentSize = subview.sizeThatFits(proposal)

        // Calculate the target position based on the percentage.
        let containerWidth = bounds.width
        let contentHalfWidth = contentSize.width / 2
        let targetX = containerWidth * percent

        // Calculate left offset.
        let leftSpacerWidth = max(0, targetX - (preserveBounds ? contentHalfWidth : 0))
        let xOffset = bounds.minX + leftSpacerWidth

        // Place the content view.
        subview.place(
            at: CGPoint(x: xOffset, y: bounds.midY - contentSize.height / 2),
            proposal: ProposedViewSize(width: contentSize.width, height: contentSize.height)
        )
    }
}

// MARK: - Preview

#Preview {
    VStack {
        BoundedView(percent: 0, preserveBounds: true) {
            Image(system: .triangleFill)
                .frame(50)
                .background(.red.gradient)
        }

        BoundedView(percent: 0.5, preserveBounds: true) {
            Text("Hello World")
                .padding()
                .background(.blue.gradient)
        }

        BoundedView(percent: 1, preserveBounds: true) {
            Text(Date().formatted())
                .padding()
                .background(.green.gradient)
        }
    }
    .foregroundStyle(.white)
    .fixedSize(horizontal: false, vertical: true)
    .frame(height: 200)
    .background(.indigo)
    .cornerRadius(AppConstants.tileCornerRadius)
    .padding(.horizontal, .defaultSpacing)
}
