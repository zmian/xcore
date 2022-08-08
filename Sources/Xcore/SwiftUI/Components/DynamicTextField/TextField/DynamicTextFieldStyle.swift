//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Style

public protocol DynamicTextFieldStyle {
    associatedtype Body: View
    typealias Configuration = DynamicTextFieldStyleConfiguration

    @ViewBuilder
    func makeBody(configuration: Self.Configuration) -> Self.Body
}

// MARK: - Configuration

public struct DynamicTextFieldStyleConfiguration {
    /// A type-erased input field of a text field.
    public struct TextField: View {
        public let body: AnyView

        init<Content: View>(_ content: Content) {
            body = content.eraseToAnyView()
        }
    }

    /// A type-erased label of a text field.
    public struct Label: View {
        public let body: AnyView

        init<Content: View>(_ content: Content) {
            body = content.eraseToAnyView()
        }
    }

    /// A view that represents the text field.
    public let textField: TextField

    /// A view that represents the label of the text field.
    public let label: Label

    /// A property representing text field configuration.
    public let configuration: TextFieldConfiguration<AnyTextFieldFormatter>

    /// The text currently present in the text field.
    @Binding public var text: String

    /// A Boolean property indicating whether the text field entry is valid.
    public let isValid: Bool

    /// A Boolean property indicating whether the text field entry is focused.
    public let isFocused: Bool
}

// MARK: - Any Style

struct AnyDynamicTextFieldStyle: DynamicTextFieldStyle {
    private var _makeBody: (Self.Configuration) -> AnyView

    init<S: DynamicTextFieldStyle>(_ style: S) {
        _makeBody = {
            style.makeBody(configuration: $0)
                .eraseToAnyView()
        }
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        _makeBody(configuration)
    }
}

// MARK: - Environment Key

extension EnvironmentValues {
    private struct DynamicTextFieldStyleKey: EnvironmentKey {
        static var defaultValue = AnyDynamicTextFieldStyle(DefaultDynamicTextFieldStyle())
    }

    var dynamicTextFieldStyle: AnyDynamicTextFieldStyle {
        get { self[DynamicTextFieldStyleKey.self] }
        set { self[DynamicTextFieldStyleKey.self] = newValue }
    }
}

// MARK: - View Helper

extension View {
    /// Sets the style for text field within this view to a style with a custom
    /// appearance and standard interaction behavior.
    public func dynamicTextFieldStyle<S: DynamicTextFieldStyle>(_ style: S) -> some View {
        environment(\.dynamicTextFieldStyle, AnyDynamicTextFieldStyle(style))
    }
}
