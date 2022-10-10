//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

extension View {
    /// A view that pads this view from bottom by insets only if the keyboard is
    /// visible.
    ///
    /// - Parameter length: The amount to inset this view. If you set the value to
    ///  `nil`, it uses the `.defaultSpacing`. The default is `nil`.
    /// - Returns: A view that pads this view's bottom inset with specified amount
    ///   of padding.
    public func keyboardSpecificBottomPadding(_ length: CGFloat? = nil) -> some View {
        modifier(KeyboardSpecificBottomPaddingModifier(length: length))
    }
}

// MARK: - ViewModifier

@MainActor
private struct KeyboardSpecificBottomPaddingModifier: ViewModifier {
    @State private var isKeyboardShown = false
    let length: CGFloat?

    func body(content: Content) -> some View {
        content
            .padding(.bottom, padding)
            .onReceive(Publishers.keyboardShown) { value in
                isKeyboardShown = value
            }
    }

    private var padding: CGFloat {
        isKeyboardShown ? (length ?? .defaultSpacing) : 0
    }
}
