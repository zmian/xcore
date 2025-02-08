//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A progress view that visually indicates its progress using a horizontal
/// line.
///
/// This style draws a capsule-shaped progress bar that fills from left to right
/// based on the provided fraction. The unfilled portion is rendered with
/// reduced opacity. If no progress value is provided, the style falls back to
/// the default `ProgressView` appearance.
///
/// **Usage**
///
/// ```swift
/// ProgressView(value: 0.5) {
///     Text("Progress Label")
/// }
/// .progressViewStyle(.line)
/// .tint(.green)
/// ```
///
/// To customize the height of the progress bar, use the `.line(height:)`
/// variant.
public struct LineProgressViewStyle: ProgressViewStyle {
    private let height: CGFloat?

    /// Creates a line progress view style with an optional custom height.
    ///
    /// - Parameter height: The height of the progress bar. If `nil`, a default
    ///   value of 4 points is used.
    init(height: CGFloat? = nil) {
        self.height = height
    }

    public func makeBody(configuration: Configuration) -> some View {
        if let progress = configuration.fractionCompleted {
            AxisGeometryReader { width in
                VStack(alignment: .leading) {
                    configuration.label

                    ZStack(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(.tint)
                            .opacity(0.3)

                        Capsule()
                            .frame(width: width * progress, alignment: .leading)
                            .foregroundStyle(.tint)
                    }
                    .frame(height: height ?? 4)
                }
            }
        } else {
            ProgressView(configuration)
        }
    }
}

// MARK: - Dot Syntax Support

extension ProgressViewStyle where Self == LineProgressViewStyle {
    /// A progress view that visually indicates its progress using a horizontal
    /// line.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// ProgressView(value: 0.5) {
    ///     Text("Progress Label")
    /// }
    /// .progressViewStyle(.line)
    /// ```
    public static var line: Self { .init() }

    /// A progress view that visually indicates its progress using a horizontal
    /// line.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// ProgressView(value: 0.5) {
    ///     Text("Progress Label")
    /// }
    /// .progressViewStyle(.line(height: 16))
    /// ```
    ///
    /// - Parameter height: The desired height of the progress bar.
    /// - Returns: A configured line progress view style.
    public static func line(height: CGFloat?) -> Self {
        .init(height: height)
    }
}

// MARK: - Preview

#Preview {
    Group {
        ProgressView()

        ProgressView(value: 0.5) {
            Text("Progress Label")
        }
        .tint(.green)

        ProgressView(value: 0.5) {
            Text("Progress Label")
        }
        .progressViewStyle(.line)
        .tint(.green)

        ProgressView(value: 0.8)
            .progressViewStyle(.line)

        ProgressView(value: 0.0)
            .progressViewStyle(.line)

        ProgressView(value: 1.0)
            .progressViewStyle(.line)
            .tint(.yellow)

        ProgressView(value: 0.7)
            .progressViewStyle(.line(height: 16))
            .tint(.yellow)
    }
    .padding(.defaultSpacing)
}
