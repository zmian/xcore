//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct TextFieldAttributes: Sendable, Hashable, MutableAppliable {
    public enum PlaceholderBehavior: Sendable, Hashable, CaseIterable {
        case floating
        case inline
    }

    public var placeholderBehavior: PlaceholderBehavior
    public var placeholderColor: Color
    public var placeholderErrorColor: Color
    public var placeholderSuccessColor: Color
    public var errorColor: Color
    public var successColor: Color
    public var disabledColor: Color?

    public init(
        placeholderBehavior: PlaceholderBehavior = .floating,
        placeholderColor: Color = Color(uiColor: .placeholderText),
        placeholderErrorColor: Color = .orange,
        placeholderSuccessColor: Color = .green,
        errorColor: Color = .orange,
        successColor: Color = .green,
        disabledColor: Color? = nil
    ) {
        self.placeholderBehavior = placeholderBehavior
        self.placeholderColor = placeholderColor
        self.placeholderErrorColor = placeholderErrorColor
        self.placeholderSuccessColor = placeholderSuccessColor
        self.errorColor = errorColor
        self.successColor = successColor
        self.disabledColor = disabledColor
    }
}

// MARK: - Environment

extension EnvironmentValues {
    @Entry public var textFieldAttributes = TextFieldAttributes()
}

// MARK: - View Helpers

extension View {
    public func textFieldAttributes(_ attributes: TextFieldAttributes) -> some View {
        environment(\.textFieldAttributes, attributes)
    }

    public func textFieldAttributes(_ transform: @escaping (inout TextFieldAttributes) -> Void) -> some View {
        transformEnvironment(\.textFieldAttributes, transform: transform)
    }
}
