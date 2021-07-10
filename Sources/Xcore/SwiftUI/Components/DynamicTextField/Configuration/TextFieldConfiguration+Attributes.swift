//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct TextFieldAttributes: MutableAppliable {
    public var placeholderColor: Color
    public var placeholderErrorColor: Color
    public var placeholderSuccessColor: Color
    public var errorColor: Color
    public var successColor: Color
    public var disabledColor: Color?
    public var disableFloatingPlaceholder: Bool

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

    public func textFieldAttributes(_ transform: @escaping (inout TextFieldAttributes) -> Void) -> some View {
        transformEnvironment(\.textFieldAttributes, transform: transform)
    }
}
