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
    /// A type-erased label of a text field.
    public struct Label: View {
        public let body: AnyView

        init<Content: View>(_ content: Content) {
            body = content.eraseToAnyView()
        }
    }

    public let label: Label

    public let configuration: TextFieldConfiguration<AnyTextFieldFormatter>

    /// The text currently present in the text field.
    public let text: String

    /// A boolean property indicating whether the text field entry is valid.
    public let isValid: Bool

    /// A boolean property indicating whether the text field entry is focused.
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

extension View {
    /// Sets the style for text field within this view to a style with a custom
    /// appearance and standard interaction behavior.
    public func dynamicTextFieldStyle<S: DynamicTextFieldStyle>(_ style: S) -> some View {
        environment(\.dynamicTextFieldStyle, AnyDynamicTextFieldStyle(style))
    }
}

// MARK: - Default Style

private struct DefaultDynamicTextFieldStyle: DynamicTextFieldStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

// MARK: - Line Style

public struct LineDynamicTextFieldStyle: DynamicTextFieldStyle {
    private let withValidationColors: Bool
    private let height: CGFloat?

    init(withValidationColors: Bool = true, height: CGFloat? = nil) {
        self.withValidationColors = withValidationColors
        self.height = height
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.textFieldAttributes) { attributes in
            EnvironmentReader(\.theme) { theme in
                let color: Color = {
                    if withValidationColors, configuration.isFocused {
                        return configuration.isValid ? attributes.successColor : attributes.errorColor
                    }

                    return Color(theme.separatorColor)
                }()

                VStack(alignment: .leading, spacing: .s2) {
                    configuration.label
                    color.frame(height: height ?? .onePixel)
                }
            }
        }
    }
}

// MARK: - Convenience

extension DynamicTextFieldStyle where Self == LineDynamicTextFieldStyle {
    public static var line: Self { line() }

    public static func line(withValidationColors: Bool = true, height: CGFloat? = nil) -> Self {
        Self(withValidationColors: withValidationColors, height: height)
    }
}
