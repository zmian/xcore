//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A progress view that visually indicates its progress using a horizontal bar.
public struct HorizontalBarProgressViewStyle: ProgressViewStyle {
    private let height: CGFloat?

    public init(height: CGFloat? = nil) {
        self.height = height
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        if let progress = configuration.fractionCompleted {
            AxisGeometryReader { width in
                VStack(alignment: .leading) {
                    configuration.label

                    ZStack(alignment: .leading) {
                        Capsule()
                            .foregroundColor(.accentColor.opacity(0.3))

                        Capsule()
                            .frame(width: width * CGFloat(progress), alignment: .leading)
                            .foregroundColor(.accentColor.opacity(0.9))
                    }
                    .frame(height: height ?? 4)
                }
            }
        } else {
            ProgressView(configuration)
        }
    }
}

struct HorizontalBarProgressViewStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProgressView()
                .colorScheme(.dark)

            ProgressView(value: 0.5)
                .accentColor(.green)

            ProgressView(value: 0.8)
                .progressViewStyle(.horizontalBar)

            ProgressView(value: 0.0)
                .progressViewStyle(.horizontalBar)

            ProgressView(value: 1.0)
                .progressViewStyle(.horizontalBar)
                .accentColor(.yellow)

            ProgressView(value: 0.8)
                .progressViewStyle(.horizontalBar)
                .accentColor(.green)
        }
        .padding(20)
        .backgroundColor(.black)
        .previewLayout(.sizeThatFits)
    }
}

// MARK: - Convenience

extension ProgressViewStyle where Self == HorizontalBarProgressViewStyle {
    public static var horizontalBar: Self { Self() }

    public static func horizontalBar(height: CGFloat?) -> Self {
        Self(height: height)
    }
}
