//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A structure representing constants related to theming of the app.
///
/// - Note: Any instance of the theme doesn't not represent `light` or `dark`
///   modes. As per iOS, it's the responsibility of `UIColor` object to declare
///   dynamic version.
///
/// If parts of the app requires a certain screen to always be in darker mode
/// you should use the iOS API to force `UITraitCollection` to always be `.dark`
/// mode.
///
/// If some screens are always in darker appearance, meaning dark blue when
/// color scheme is `.light` and black when color scheme is `.dark` then you
/// should create a new theme instance that represent such conditions. One
/// possible solution is to name this instance `midnight` to indicate that this
/// theme instance will always reflect darker appearance.
///
/// ```swift
/// extension Theme {
///     /// A theme that has midnight appearance when color scheme is `.light` and
///     /// darker appearance when color scheme is `.dark`.
///     public static let midnight: Theme(...)
/// }
/// ```
@dynamicMemberLookup
public struct Theme: MutableAppliable, UserInfoContainer {
    public typealias Identifier = Xcore.Identifier<Self>
    public typealias ButtonColor = (ButtonIdentifier, ButtonState, ElementPosition) -> UIColor

    /// A unique id for the theme.
    public var id: Identifier

    /// A color that represents the system or application tint color.
    public var tintColor: UIColor

    /// The color for divider lines that hides any underlying content.
    public var separatorColor: UIColor

    /// The color for border lines that hides any underlying content.
    public var borderColor: UIColor

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public var toggleColor: UIColor

    /// The color for links.
    public var linkColor: UIColor

    /// The color for placeholder text in controls or text views.
    public var placeholderTextColor: UIColor

    // MARK: - Sentiment Color

    /// The color for representing positive sentiment.
    ///
    /// Use sentiment colors for items that represent positive or negative outcomes.
    /// Use this color to for outcomes, such as the validation succeeded.
    public var positiveSentimentColor: UIColor

    /// The color for representing negative sentiment.
    ///
    /// Use sentiment colors for items that represent positive or negative outcomes.
    /// Use this color to for outcomes, such as the validation failed or require
    /// user's attention.
    public var negativeSentimentColor: UIColor

    // MARK: - Text

    /// The color for text labels that contain primary content.
    public var textColor: UIColor

    /// The color for text labels that contain secondary content.
    public var textSecondaryColor: UIColor

    /// The color for text labels that contain tertiary content.
    public var textTertiaryColor: UIColor

    /// The color for text labels that contain quaternary content.
    public var textQuaternaryColor: UIColor

    // MARK: - Background

    /// The color for the main background of your interface.
    public var backgroundColor: UIColor

    /// The color for content layered on top of the main background.
    public var backgroundSecondaryColor: UIColor

    /// The color for content layered on top of secondary backgrounds.
    public var backgroundTertiaryColor: UIColor

    // MARK: - Grouped Background

    /// The color for the main background of your grouped interface.
    public var groupedBackgroundColor: UIColor

    /// The color for content layered on top of the main background of your grouped
    /// interface.
    public var groupedBackgroundSecondaryColor: UIColor

    /// The color for content layered on top of secondary backgrounds of your
    /// grouped interface.
    public var groupedBackgroundTertiaryColor: UIColor

    // MARK: - Button

    public var buttonTextColor: ButtonColor
    public var buttonBackgroundColor: ButtonColor

    // MARK: - Chrome

    public var statusBarStyle: UIStatusBarStyle
    public var chrome: Chrome.Style

    /// Additional info which may be used to describe the theme further.
    public var userInfo: UserInfo

    public init(
        id: Identifier,
        tintColor: UIColor,
        separatorColor: UIColor,
        borderColor: UIColor,
        toggleColor: UIColor,
        linkColor: UIColor,
        placeholderTextColor: UIColor,

        // Sentiment
        positiveSentimentColor: UIColor,
        negativeSentimentColor: UIColor,

        // Text
        textColor: UIColor,
        textSecondaryColor: UIColor,
        textTertiaryColor: UIColor,
        textQuaternaryColor: UIColor,

        // Background
        backgroundColor: UIColor,
        backgroundSecondaryColor: UIColor,
        backgroundTertiaryColor: UIColor,

        // Grouped Background
        groupedBackgroundColor: UIColor,
        groupedBackgroundSecondaryColor: UIColor,
        groupedBackgroundTertiaryColor: UIColor,

        // Button
        buttonTextColor: @escaping ButtonColor,
        buttonBackgroundColor: @escaping ButtonColor,

        // Chrome
        statusBarStyle: UIStatusBarStyle,
        chrome: Chrome.Style,

        // UserInfo
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.borderColor = borderColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.placeholderTextColor = placeholderTextColor

        // Sentiment
        self.positiveSentimentColor = positiveSentimentColor
        self.negativeSentimentColor = negativeSentimentColor

        // Text
        self.textColor = textColor
        self.textSecondaryColor = textSecondaryColor
        self.textTertiaryColor = textTertiaryColor
        self.textQuaternaryColor = textQuaternaryColor

        // Background
        self.backgroundColor = backgroundColor
        self.backgroundSecondaryColor = backgroundSecondaryColor
        self.backgroundTertiaryColor = backgroundTertiaryColor

        // Grouped Background
        self.groupedBackgroundColor = groupedBackgroundColor
        self.groupedBackgroundSecondaryColor = groupedBackgroundSecondaryColor
        self.groupedBackgroundTertiaryColor = groupedBackgroundTertiaryColor

        // Button
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor

        // Chrome
        self.statusBarStyle = statusBarStyle
        self.chrome = chrome

        // UserInfo
        self.userInfo = userInfo
    }
}

// MARK: - Convenience

extension Theme {
    public func buttonBackgroundColor(_ id: ButtonIdentifier, _ state: ButtonState = .normal) -> UIColor {
        buttonBackgroundColor(id, state, .primary)
    }

    public func buttonTextColor(_ id: ButtonIdentifier, _ state: ButtonState = .normal) -> UIColor {
        buttonTextColor(id, state, .primary)
    }
}

// MARK: - KeyPath

extension Theme {
    public static subscript<T>(dynamicMember keyPath: KeyPath<Self, T>) -> T {
        `default`[keyPath: keyPath]
    }

    public static subscript<T>(dynamicMember keyPath: WritableKeyPath<Self, T>) -> T {
        get { `default`[keyPath: keyPath] }
        set { `default`[keyPath: keyPath] = newValue }
    }
}

// MARK: - Equatable

extension Theme: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Theme: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Default

extension Theme {
    /// The default theme for the interface.
    public static var `default`: Theme = .system

    /// The system theme using [UI Element Colors] for the interface.
    ///
    /// [UI Element Colors]: https://developer.apple.com/documentation/uikit/uicolor/ui_element_colors
    private static let system = Theme(
        id: "system",
        tintColor: .systemTint,
        separatorColor: .separator,
        borderColor: .separator,
        toggleColor: .systemGreen,
        linkColor: .link,
        placeholderTextColor: .placeholderText,

        // Sentiment
        positiveSentimentColor: .systemGreen,
        negativeSentimentColor: .systemRed,

        // Text
        textColor: .label,
        textSecondaryColor: .secondaryLabel,
        textTertiaryColor: .tertiaryLabel,
        textQuaternaryColor: .quaternaryLabel,

        // Background
        backgroundColor: .systemBackground,
        backgroundSecondaryColor: .secondarySystemBackground,
        backgroundTertiaryColor: .tertiarySystemBackground,

        // Grouped Background
        groupedBackgroundColor: .systemGroupedBackground,
        groupedBackgroundSecondaryColor: .secondarySystemGroupedBackground,
        groupedBackgroundTertiaryColor: .tertiarySystemGroupedBackground,

        // Button Text
        buttonTextColor: { style, state, position in
            switch (style, state, position) {
                case (.outline, .normal, _),
                     (.outline, .pressed, _):
                    return .label

                case (_, .normal, _):
                    return .white
                case (_, .pressed, _):
                    return .white
                case (_, .disabled, _):
                    return .systemGray4
            }
        },

        // Button Background
        buttonBackgroundColor: { style, state, position in
            switch (style, state, position) {
                case (_, .normal, _):
                    return .systemTint
                case (_, .pressed, _):
                    return .systemTint
                case (_, .disabled, _):
                    return .secondarySystemBackground
            }
        },

        // Chrome
        statusBarStyle: .default,
        chrome: .blurred
    )
}
