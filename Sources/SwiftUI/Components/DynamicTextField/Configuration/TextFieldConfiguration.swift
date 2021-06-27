//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public enum SecureTextEntry: String {
        /// The text will be visible.
        case no

        /// The text will be masked to enter private text.
        case yes

        /// The text will be masked to enter private text. The textfield will have
        /// toggle button to unmask the text.
        case yesWithToggleButton
    }
}

public struct TextFieldConfiguration<Formatter: TextFieldFormatter>: Equatable, Identifiable, UserInfoContainer, MutableAppliable {
    public typealias ID = Identifier<Self>

    /// A unique id for the configuration.
    public var id: ID

    /// The default value is `.sentences`.
    public var autocapitalization: UITextAutocapitalizationType

    /// The default value is `.default`.
    public var autocorrection: UITextAutocorrectionType

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
        autocapitalization: UITextAutocapitalizationType = .sentences,
        autocorrection: UITextAutocorrectionType = .default,
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
        self.autocorrection = autocorrection
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

// MARK: - Convenience Init

extension TextFieldConfiguration where Formatter == PassthroughTextFieldFormatter {
    public init(
        id: ID,
        autocapitalization: UITextAutocapitalizationType = .sentences,
        autocorrection: UITextAutocorrectionType = .default,
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
            autocorrection: autocorrection,
            spellChecking: spellChecking,
            keyboard: keyboard,
            textContentType: textContentType,
            secureTextEntry: secureTextEntry,
            isEditable: isEditable,
            validation: validation,
            formatter: Formatter()
        )
    }
}

// MARK: - Equatable

extension TextFieldConfiguration {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
            lhs.autocapitalization == rhs.autocapitalization &&
            lhs.autocorrection == rhs.autocorrection &&
            lhs.spellChecking == rhs.spellChecking &&
            lhs.keyboard == rhs.keyboard &&
            lhs.textContentType == rhs.textContentType &&
            lhs.secureTextEntry == rhs.secureTextEntry &&
            lhs.isEditable == rhs.isEditable
    }
}

// MARK: - Convenience

extension TextFieldConfiguration where Formatter == AnyTextFieldFormatter {
    /// Erase formatter
    init<F: TextFieldFormatter>(_ configuration: TextFieldConfiguration<F>) {
        self.init(
            id: .init(rawValue: configuration.id.rawValue),
            autocapitalization: configuration.autocapitalization,
            autocorrection: configuration.autocorrection,
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
