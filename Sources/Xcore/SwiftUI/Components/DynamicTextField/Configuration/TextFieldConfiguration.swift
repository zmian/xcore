//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// An enumeration representing the type of secure text entry.
    public enum SecureTextEntry: String, Sendable {
        /// The text will be visible.
        case no

        /// The text will be masked to enter private text.
        case yes

        /// The text will be masked to enter private text. The textfield will have
        /// toggle button to unmask the text.
        case yesWithToggleButton
    }
}

/// A structure representing text field configuration.
public struct TextFieldConfiguration<Formatter: TextFieldFormatter>: Sendable, Equatable, Identifiable, UserInfoContainer, MutableAppliable {
    public typealias ID = Identifier<Self>

    /// A unique id for the configuration.
    public var id: ID

    /// The default value is `.sentences`.
    public var autocapitalization: TextInputAutocapitalization

    /// The default value is `true`.
    public var autocorrectionDisabled: Bool

    /// The default value is `.default`.
    public var spellChecking: UITextSpellCheckingType

    /// The default value is `.default`.
    public var keyboard: UIKeyboardType

    /// The default value is `nil`.
    public var textContentType: UITextContentType?

    /// The default value is `.no`.
    public var secureTextEntry: SecureTextEntry

    /// The default value is `true`.
    public var isEditable: Bool

    /// A validation rule that checks whether the input is valid.
    ///
    /// The default value is `.none`.
    public var validation: ValidationRule<String>

    /// A formatter to use when converting between values and their textual
    /// representations.
    public var formatter: Formatter

    /// Additional info which may be used to extend the configuration further.
    public var userInfo: UserInfo

    public init(
        id: ID,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = true,
        spellChecking: UITextSpellCheckingType = .default,
        keyboard: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        secureTextEntry: SecureTextEntry = .no,
        isEditable: Bool = true,
        validation: ValidationRule<String> = .none,
        formatter: Formatter,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.spellChecking = spellChecking
        self.keyboard = keyboard
        self.textContentType = textContentType
        self.secureTextEntry = secureTextEntry
        self.isEditable = isEditable
        self.validation = validation
        self.formatter = formatter
        self.userInfo = userInfo
    }
}

// MARK: - Equatable

extension TextFieldConfiguration {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
            // TODO: Restore when autocapitalization is Equatable
            // lhs.autocapitalization == rhs.autocapitalization &&
            lhs.autocorrectionDisabled == rhs.autocorrectionDisabled &&
            lhs.spellChecking == rhs.spellChecking &&
            lhs.keyboard == rhs.keyboard &&
            lhs.textContentType == rhs.textContentType &&
            lhs.secureTextEntry == rhs.secureTextEntry &&
            lhs.isEditable == rhs.isEditable
    }
}

// MARK: - Inits

extension TextFieldConfiguration<AnyTextFieldFormatter> {
    /// Erase formatter
    init<F: TextFieldFormatter>(_ configuration: TextFieldConfiguration<F>) {
        self.init(
            id: .init(rawValue: configuration.id.rawValue),
            autocapitalization: configuration.autocapitalization,
            autocorrectionDisabled: configuration.autocorrectionDisabled,
            spellChecking: configuration.spellChecking,
            keyboard: configuration.keyboard,
            textContentType: configuration.textContentType,
            secureTextEntry: .init(rawValue: configuration.secureTextEntry.rawValue)!,
            isEditable: configuration.isEditable,
            validation: configuration.validation,
            formatter: .init(configuration.formatter),
            userInfo: configuration.userInfo.mapPairs {
                (UserInfo.Key(rawValue: $0.key.rawValue), $0.value)
            }
        )
    }
}

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    public init(
        id: ID,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = true,
        spellChecking: UITextSpellCheckingType = .default,
        keyboard: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        secureTextEntry: SecureTextEntry = .no,
        isEditable: Bool = true,
        validation: ValidationRule<String> = .none
    ) {
        self.init(
            id: id,
            autocapitalization: autocapitalization,
            autocorrectionDisabled: autocorrectionDisabled,
            spellChecking: spellChecking,
            keyboard: keyboard,
            textContentType: textContentType,
            secureTextEntry: secureTextEntry,
            isEditable: isEditable,
            validation: validation,
            formatter: .init()
        )
    }
}
