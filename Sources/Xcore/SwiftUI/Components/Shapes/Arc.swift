//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct Arc: InsettableShape, Sendable {
    public let startAngle: Angle
    public let endAngle: Angle
    public let clockwise: Bool
    private let insetAmount: CGFloat

    public init(startAngle: Angle, endAngle: Angle, clockwise: Bool) {
        self.init(
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise,
            insetAmount: 0
        )
    }

    private init(
        startAngle: Angle,
        endAngle: Angle,
        clockwise: Bool,
        insetAmount: CGFloat
    ) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.clockwise = clockwise
        self.insetAmount = insetAmount
    }

    public func path(in rect: CGRect) -> Path {
        Path {
            let rect = rect.insetBy(dx: insetAmount, dy: insetAmount)

            $0.addArc(
                center: CGPoint(x: rect.midX, y: rect.maxY + insetAmount),
                radius: rect.width / 2,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: clockwise
            )
        }
    }

    public func inset(by amount: CGFloat) -> Self {
        Arc(
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise,
            insetAmount: amount
        )
    }
}

// MARK: - Preview

#Preview {
    Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
        .strokeBorder(
            AngularGradient(
                gradient: Gradient(colors: [.white, .orange]),
                center: .center,
                startAngle: .degrees(180),
                endAngle: .degrees(360)
            ),
            lineWidth: 50
        )
        .background(Color.black.opacity(0.5))
        .aspectRatio(CGSize(width: 1, height: 0.5), contentMode: .fit)
        .previewLayout(.sizeThatFits)
}
