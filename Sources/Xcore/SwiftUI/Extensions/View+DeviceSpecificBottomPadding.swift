//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// A view that pads this view from bottom by insets only if this device doesn't
    /// support home indicator.
    ///
    /// - Parameter length: The amount to inset this view. If you set the value to
    ///  `nil`, it uses the `.defaultSpacing`. The default is `nil`.
    /// - Returns: A view that pads this view's bottom inset with specified amount
    ///   of padding.
    public func deviceSpecificBottomPadding(_ length: CGFloat? = nil) -> some View {
        modifier(NonHomeIndicatorPaddingModifier(length: length))
    }
}

// MARK: - ViewModifier

private struct NonHomeIndicatorPaddingModifier: ViewModifier {
    let length: CGFloat?

    func body(content: Content) -> some View {
        content
            .padding(.bottom, .deviceSpecificSpacing(length))
    }
}

extension CGFloat {
    /// Returns default spacing only if this device doesn't support home indicator.
    public static var deviceSpecificSpacing: Self {
        deviceSpecificSpacing(nil)
    }

    /// Returns default spacing only or provided length if this device doesn't
    /// support home indicator.
    public static func deviceSpecificSpacing(_ length: CGFloat?) -> Self {
        AppConstants.supportsHomeIndicator ? 0 : (length ?? .defaultSpacing)
    }
}
