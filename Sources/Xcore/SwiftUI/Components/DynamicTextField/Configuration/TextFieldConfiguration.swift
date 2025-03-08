//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// An enumeration representing the text entry mode for a text field.
    ///
    /// Use this enumeration to configure how sensitive text is displayed. When set to
    /// `.plain`, the text is visible. When set to `.masked`, the text is obscured to
    /// protect sensitive information. The `.maskedWithToggle` mode obscures the text by
    /// default but provides a toggle to reveal it temporarily.
    public enum TextEntryMode: String, Sendable {
        /// The text is displayed normally without any masking.
        case plain

        /// The text is masked for secure private input.
        case masked

        /// The text is masked by default, with a toggle button available to unmask it
        /// temporarily.
        case maskedWithToggle
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

    /// The default value is `.plain`.
    public var textEntryMode: TextEntryMode

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
        textEntryMode: TextEntryMode = .plain,
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
        self.textEntryMode = textEntryMode
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
            lhs.textEntryMode == rhs.textEntryMode &&
            lhs.isEditable == rhs.isEditable
    }
}

// MARK: - Inits

extension TextFieldConfiguration<AnyTextFieldFormatter> {
    /// Erase formatter
    init(_ configuration: TextFieldConfiguration<some TextFieldFormatter>) {
        self.init(
            id: .init(rawValue: configuration.id.rawValue),
            autocapitalization: configuration.autocapitalization,
            autocorrectionDisabled: configuration.autocorrectionDisabled,
            spellChecking: configuration.spellChecking,
            keyboard: configuration.keyboard,
            textContentType: configuration.textContentType,
            textEntryMode: .init(rawValue: configuration.textEntryMode.rawValue)!,
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
        textEntryMode: TextEntryMode = .plain,
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
            textEntryMode: textEntryMode,
            isEditable: isEditable,
            validation: validation,
            formatter: .init()
        )
    }
}
