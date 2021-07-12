//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A triangle centered on the frame of the view containing it.
public struct Triangle: Shape {
    public init() {}

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path {
        Path {
            $0.move(to: CGPoint(x: rect.midX, y: rect.origin.y))
            $0.addLine(to: CGPoint(x: rect.width, y: rect.height))
            $0.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
            $0.closeSubpath()
        }
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
            .stroke(lineWidth: 13)
            .frame(300)
            .padding()
    }
}
