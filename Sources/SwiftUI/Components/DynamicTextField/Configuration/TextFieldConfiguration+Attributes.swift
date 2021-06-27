//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct TextFieldAttributes {
    public let placeholderColor: Color
    public let placeholderErrorColor: Color
    public let placeholderSuccessColor: Color
    public let errorColor: Color
    public let successColor: Color
    public let disabledColor: Color?
    public let disableFloatingPlaceholder: Bool

    public init(
        placeholderColor: Color = Color(.placeholderText),
        placeholderErrorColor: Color = Color(.systemOrange),
        placeholderSuccessColor: Color = Color(.systemGreen),
        errorColor: Color = Color(.systemOrange),
        successColor: Color = Color(.systemGreen),
        disabledColor: Color? = nil,
        disableFloatingPlaceholder: Bool = false
    ) {
        self.placeholderColor = placeholderColor
        self.placeholderErrorColor = placeholderErrorColor
        self.placeholderSuccessColor = placeholderSuccessColor
        self.errorColor = errorColor
        self.successColor = successColor
        self.disabledColor = disabledColor
        self.disableFloatingPlaceholder = disableFloatingPlaceholder
    }
}

// MARK: - Environment

extension EnvironmentValues {
    private struct AttributesKey: EnvironmentKey {
        static var defaultValue: TextFieldAttributes = .init()
    }

    public var textFieldAttributes: TextFieldAttributes {
        get { self[AttributesKey.self] }
        set { self[AttributesKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func textFieldAttributes(_ attributes: TextFieldAttributes) -> some View {
        environment(\.textFieldAttributes, attributes)
    }
}
