//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct TextFieldAttributes: Hashable, MutableAppliable {
    public enum PlaceholderPlacement: Hashable, CaseIterable {
        case floating
        case inline
        case top
    }

    public var placeholderColor: Color
    public var placeholderErrorColor: Color
    public var placeholderSuccessColor: Color
    public var errorColor: Color
    public var successColor: Color
    public var disabledColor: Color?
    public var placeholderPlacement: PlaceholderPlacement

    public init(
        placeholderColor: Color = Color(.placeholderText),
        placeholderErrorColor: Color = Color(.systemOrange),
        placeholderSuccessColor: Color = Color(.systemGreen),
        errorColor: Color = Color(.systemOrange),
        successColor: Color = Color(.systemGreen),
        disabledColor: Color? = nil,
        placeholderPlacement: PlaceholderPlacement = .floating
    ) {
        self.placeholderColor = placeholderColor
        self.placeholderErrorColor = placeholderErrorColor
        self.placeholderSuccessColor = placeholderSuccessColor
        self.errorColor = errorColor
        self.successColor = successColor
        self.disabledColor = disabledColor
        self.placeholderPlacement = placeholderPlacement
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
