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

// MARK: - Prominent Style

public struct ProminentDynamicTextFieldStyle: DynamicTextFieldStyle {
    public struct Options: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let bordered = Self(rawValue: 1 << 0)
        public static let elevated = Self(rawValue: 1 << 1)
    }

    private let cornerRadius: CGFloat
    private let options: Options

    init(cornerRadius: CGFloat, options: Options) {
        self.cornerRadius = cornerRadius
        self.options = options
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.textFieldAttributes) { attributes in
            EnvironmentReader(\.theme) { theme in
                configuration.label
                    .apply {
                        if attributes.disableFloatingPlaceholder {
                            $0.padding(.horizontal, .minimumPadding)
                                .padding(.vertical, .defaultPadding)
                        } else {
                            $0.padding(.minimumPadding)
                        }
                    }
                    .when(options.contains(.elevated)) {
                        $0.backgroundColor(theme.backgroundSecondaryColor)
                    }
                    .cornerRadius(cornerRadius)
                    .when(options.contains(.bordered)) {
                        $0.border(cornerRadius: cornerRadius, width: 0.5)
                    }
            }
        }
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

                VStack(alignment: .leading, spacing: .minimumPadding) {
                    configuration.label
                    color.frame(height: height ?? .onePixel)
                }
            }
        }
    }
}

// MARK: - Convenience

extension DynamicTextFieldStyle where Self == ProminentDynamicTextFieldStyle {
    public static var prominent: Self { prominent() }

    public static func prominent(
        cornerRadius: CGFloat = AppConstants.tileCornerRadius,
        options: Self.Options = .elevated
    ) -> Self {
        Self(cornerRadius: cornerRadius, options: options)
    }
}

extension DynamicTextFieldStyle where Self == LineDynamicTextFieldStyle {
    public static var line: Self { line() }

    public static func line(withValidationColors: Bool = true, height: CGFloat? = nil) -> Self {
        Self(withValidationColors: withValidationColors, height: height)
    }
}
