//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A parallelogram centered on the frame of the view containing it.
///
/// - SeeAlso: https://trailingclosure.com/swiftui-parallelogram-shape
public struct Parallelogram: Shape {
    private let depth: CGFloat
    private let isFlipped: Bool

    public init(depth: CGFloat, isFlipped: Bool = false) {
        self.depth = depth
        self.isFlipped = isFlipped
    }

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path {
        Path {
            if isFlipped {
                $0.move(to: CGPoint(x: 0, y: 0))
                $0.addLine(to: CGPoint(x: rect.width, y: depth))
                $0.addLine(to: CGPoint(x: rect.width, y: rect.height))
                $0.addLine(to: CGPoint(x: 0, y: rect.height - depth))
            } else {
                $0.move(to: CGPoint(x: 0, y: depth))
                $0.addLine(to: CGPoint(x: rect.width, y: 0))
                $0.addLine(to: CGPoint(x: rect.width, y: rect.height - depth))
                $0.addLine(to: CGPoint(x: 0, y: rect.height))
            }
            $0.closeSubpath()
        }
    }
}

struct Parallelogram_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Parallelogram(depth: 150)
                .stroke(Color.black, lineWidth: 13)

            Parallelogram(depth: 150, isFlipped: true)
                .stroke(Color.red, lineWidth: 13)
        }
        .frame(300)
        .padding()
    }
}
