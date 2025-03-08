//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in a navigation stack.
    func embedInNavigation() -> some View {
        NavigationStack { self }
    }
}

// MARK: - Button Styles

extension ButtonStyle where Self == ProminentButtonStyle<Capsule> {
    static var primary: Self { capsuleFill }
    static var secondary: Self { capsuleOutline }
}

// MARK: - Text Field Styles

extension DynamicTextFieldStyle where Self == PrimaryDynamicTextFieldStyle {
    /// Placeholder placement is inline of the text field.
    static var primary: Self {
        .init()
    }
}

struct PrimaryDynamicTextFieldStyle: DynamicTextFieldStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProminentDynamicTextFieldStyle(.outline, shape: .capsule)
            .makeBody(configuration: configuration)
            .textFieldAttributes {
                $0.placeholderPlacement = .inline
            }
    }
}
