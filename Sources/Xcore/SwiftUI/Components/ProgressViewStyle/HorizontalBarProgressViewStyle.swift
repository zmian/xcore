//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A progress view that visually indicates its progress using a horizontal bar.
public struct HorizontalBarProgressViewStyle: ProgressViewStyle {
    private let height: CGFloat?

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
                            .frame(width: width * CGFloat(progress), alignment: .leading)
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

// MARK: - Preview

#Preview {
    Group {
        ProgressView()
            .colorScheme(.dark)

        ProgressView(value: 0.5)
            .tint(.green)

        ProgressView(value: 0.8)
            .progressViewStyle(.horizontalBar)

        ProgressView(value: 0.0)
            .progressViewStyle(.horizontalBar)

        ProgressView(value: 1.0)
            .progressViewStyle(.horizontalBar)
            .tint(.yellow)

        ProgressView(value: 0.8)
            .progressViewStyle(.horizontalBar)
            .tint(.green)
    }
    .padding(20)
    .background(.black)
    .previewLayout(.sizeThatFits)
}

// MARK: - Dot Syntax Support

extension ProgressViewStyle where Self == HorizontalBarProgressViewStyle {
    public static var horizontalBar: Self { .init() }

    public static func horizontalBar(height: CGFloat?) -> Self {
        .init(height: height)
    }
}
