//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A container view designed to house content and align it selectively to
/// either the leading or trailing edge.
///
/// It horizontally positions content by specifying a percentage (0...1). The
/// `preserveBounds` parameter provides control over whether the content extends
/// beyond the edges or is confined to either the leading or trailing edge of
/// the container.
public struct BoundedView<Content: View>: View {
    @State private var contentSize = CGSize(width: CGFloat.infinity, height: .zero)
    private let percent: Double
    private let preserveBounds: Bool
    private let content: () -> Content

    /// A container view designed to house content and align it selectively to
    /// either the leading or trailing edge.
    ///
    /// It horizontally positions content by specifying a percentage (0...1). The
    /// `preserveBounds` parameter provides control over whether the content extends
    /// beyond the edges or is confined to either the leading or trailing edge of
    /// the container.
    ///
    /// - Parameters:
    ///   - percent: A value indicating the horizontal position percentage (0...1).
    ///   - preserveBounds: A boolean determining whether the content should bleed
    ///     out the edges.
    ///   - content: A closure returning the content to be displayed.
    public init(
        percent: Double,
        preserveBounds: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.percent = percent
        self.preserveBounds = preserveBounds
        self.content = content
    }

    public var body: some View {
        // TODO: Use Layout protocol for implementation instead of GeometryReader.
        AxisGeometryReader { width in
            HStack {
                if showLeftSpacer(viewWidth: width) {
                    let spacerW = spacerWidth(viewWidth: width)
                    Spacer()
                        .applyIf(spacerW > 0) {
                            $0.frame(width: spacerW)
                        }
                }

                content()
                    .fixedSize()
                    .lineLimit(1)
                    .readSize($contentSize)

                if showRightSpacer(viewWidth: width) {
                    Spacer()
                }
            }
            .frame(maxWidth: width)
        }
    }

    private var contentSizeWidth: Double {
        contentSize.width
    }

    private func showLeftSpacer(viewWidth: Double) -> Bool {
        let currentWidth = viewWidth * percent
        let originalOffset = contentSizeWidth / 2
        return currentWidth > originalOffset
    }

    private func showRightSpacer(viewWidth: Double) -> Bool {
        let currentWidth = viewWidth * percent
        let originalOffset = contentSizeWidth / 2
        return currentWidth + originalOffset < viewWidth
    }

    private func spacerWidth(viewWidth: Double) -> Double {
        let currentWidth = viewWidth * percent
        let originalOffset = contentSizeWidth / 2

        if currentWidth < originalOffset || currentWidth + contentSizeWidth / 2 > viewWidth {
            return 0
        } else {
            return currentWidth - (preserveBounds ? originalOffset : 0)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        BoundedView(percent: 0, preserveBounds: true) {
            Image(system: .triangleFill)
        }

        BoundedView(percent: 0.5, preserveBounds: true) {
            Text("Hello World")
        }

        BoundedView(percent: 1, preserveBounds: true) {
            Text(Date().formatted(style: .narrowTime))
        }
    }
    .foregroundStyle(.white)
    .fixedSize(horizontal: false, vertical: true)
    .frame(height: 100)
    .background(.indigo)
    .cornerRadius(AppConstants.tileCornerRadius)
    .padding(.horizontal, .defaultSpacing)
}
