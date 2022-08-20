//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A flexible space that expands along the major axis of its containing stack
/// layout, or on both axes if not contained in a stack.
public func Spacer(height: CGFloat) -> some View {
    Spacer()
        .frame(height: height)
}

/// A flexible space that expands along the major axis of its containing stack
/// layout, or on both axes if not contained in a stack.
public func Spacer(width: CGFloat) -> some View {
    Spacer()
        .frame(width: width)
}
