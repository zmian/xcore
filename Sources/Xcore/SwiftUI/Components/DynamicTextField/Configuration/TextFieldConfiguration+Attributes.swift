//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Attributes used to customize the appearance and behavior of a text field.
public struct TextFieldAttributes: Sendable, Hashable, MutableAppliable {
    /// An enumeration representing the placement styles available for a text
    /// field's placeholder.
    public enum PlaceholderPlacement: Sendable, Hashable, CaseIterable {
        /// A floating placeholder that moves above the text when editing begins.
        case floating

        /// An inline placeholder displayed within the text field, disappearing upon
        /// input.
        case inline
    }

    /// The placement style of the placeholder.
    public var placeholderPlacement: PlaceholderPlacement

    /// The default color of the placeholder text.
    public var placeholderColor: Color

    /// The color of the placeholder when an error occurs.
    public var placeholderErrorColor: Color

    /// The color of the placeholder when the input is successful.
    public var placeholderSuccessColor: Color

    /// The color used to indicate errors in the placeholder and text.
    public var errorColor: Color

    /// The color used to indicate successful input or validation.
    public var successColor: Color

    /// The color applied when the text field is disabled.
    public var disabledColor: Color?

    /// Initializes a new `TextFieldAttributes` instance with specified styles.
    ///
    /// - Parameters:
    ///   - placeholderPlacement: Determines how the placeholder is displayed.
    ///   - placeholderColor: The default color of the placeholder text.
    ///   - placeholderErrorColor: The color for placeholder text in an error state.
    ///   - placeholderSuccessColor: The placeholder color indicating success.
    ///   - errorColor: The general error color used across the text field.
    ///   - successColor: The general success color used across the text field.
    ///   - disabledColor: The optional color applied when the field is disabled.
    public init(
        placeholderPlacement: PlaceholderPlacement = .floating,
        placeholderColor: Color = Color(uiColor: .placeholderText),
        placeholderErrorColor: Color = .orange,
        placeholderSuccessColor: Color = .green,
        errorColor: Color = .orange,
        successColor: Color = .green,
        disabledColor: Color? = nil
    ) {
        self.placeholderPlacement = placeholderPlacement
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
    /// The attributes applied to dynamic text fields.
    @Entry public var textFieldAttributes = TextFieldAttributes()
}

// MARK: - View Modifiers

extension View {
    /// Sets custom attributes for text fields within this view's environment.
    ///
    /// - Parameter attributes: The `TextFieldAttributes` to apply to text fields
    ///   within the view.
    /// - Returns: A view modified to use the specified text field attributes.
    public func textFieldAttributes(_ attributes: TextFieldAttributes) -> some View {
        environment(\.textFieldAttributes, attributes)
    }

    /// Modifies the text field attributes within the view's environment.
    ///
    /// Use this method to apply customized attribute transformations to text fields
    /// inside a view hierarchy.
    ///
    /// ```swift
    /// DynamicTextField(value: $email, configuration: .emailAddress) {
    ///     Label("Email Address", systemImage: "envelope")
    /// }
    /// .textFieldAttributes { attributes in
    ///     attributes.placeholderColor = .gray
    ///     attributes.placeholderPlacement = .inline
    /// }
    /// ```
    ///
    /// - Parameter transform: A closure that receives an inout reference to the
    ///   current `TextFieldAttributes`, allowing you to modify its properties
    ///   directly.
    /// - Returns: A modified view that applies the transformed attributes to its
    ///   text fields.
    public func textFieldAttributes(
        _ transform: @escaping (inout TextFieldAttributes) -> Void
    ) -> some View {
        transformEnvironment(\.textFieldAttributes, transform: transform)
    }
}
