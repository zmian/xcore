//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A dynamic text field style that applies an underline to a text field,
/// adapting its color to visually represent its validation state based on
/// focus.
///
/// If validation colors are enabled and the text field is focused and contains
/// text, the underline's color changes to reflect either a success or an error
/// state based on validation. Otherwise, it displays the theme's default
/// separator color.
///
/// **Usage**
///
/// ```swift
/// DynamicTextField(value: $email, configuration: .emailAddress) {
///     Label("Email Address", systemImage: "envelope")
/// }
/// .dynamicTextFieldStyle(.line)
/// ```
public struct LineDynamicTextFieldStyle: DynamicTextFieldStyle {
    /// A Boolean property indicating whether to use validation colors for the
    /// underline.
    private let withValidationColors: Bool

    /// The thickness of the underline; if nil, a default value of one pixel is
    /// used.
    private let height: CGFloat?

    init(withValidationColors: Bool, height: CGFloat?) {
        self.withValidationColors = withValidationColors
        self.height = height
    }

    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: .s2) {
            DynamicTextField.default(configuration)
            line(configuration: configuration)
        }
    }

    private func line(configuration: Configuration) -> some View {
        EnvironmentReader(\.theme) { theme in
            EnvironmentReader(\.textFieldAttributes) { attributes in
                let color: Color = {
                    if withValidationColors, configuration.isFocused {
                        if configuration.text.isEmpty {
                            return theme.separatorColor
                        }

                        return configuration.isValid ? attributes.successColor : attributes.errorColor
                    }

                    return theme.separatorColor
                }()

                color.frame(height: height ?? 1)
            }
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == LineDynamicTextFieldStyle {
    /// A dynamic text field style that applies an underline to a text field,
    /// adapting its color to visually represent its validation state based on
    /// focus.
    ///
    /// When the text field is focused and contains text, the underline's color
    /// changes to reflect either a success or an error state based on validation.
    /// Otherwise, it displays the theme's default separator color.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// DynamicTextField(value: $text, configuration: .emailAddress) {
    ///     Label("Email Address", systemImage: .mail)
    /// }
    /// .dynamicTextFieldStyle(.line)
    /// ```
    public static var line: Self { line() }

    /// A dynamic text field style that applies an underline to a text field,
    /// adapting its color to visually represent its validation state based on
    /// focus.
    ///
    /// If validation colors are enabled and the text field is focused and contains
    /// text, the underline's color changes to reflect either a success or an error
    /// state based on validation. Otherwise, it displays the theme's default
    /// separator color.
    ///
    /// - Parameters:
    ///   - withValidationColors: A Boolean property indicating whether the style
    ///     should reflect validation state by changing the underline color.
    ///   - height: The thickness of the underline. If `nil`, a default of one
    ///     pixel is used.
    ///
    /// - Returns: A dynamic text field style with a customizable underline.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// DynamicTextField(value: $text, configuration: .emailAddress) {
    ///     Label("Email Address", systemImage: .mail)
    /// }
    /// .dynamicTextFieldStyle(.line(withValidationColors: true, height: 2))
    /// ```
    public static func line(withValidationColors: Bool = true, height: CGFloat? = nil) -> Self {
        Self(withValidationColors: withValidationColors, height: height)
    }
}
