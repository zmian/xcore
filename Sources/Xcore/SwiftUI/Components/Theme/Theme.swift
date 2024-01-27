//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A structure representing constants related to theming of the app.
///
/// Any instance of the theme does not represent `light` or `dark` modes. As per
/// iOS, it's the responsibility of `Color` object to declare dynamic version.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @Environment(\.theme) private var theme
///     @State var landmarks = ["Lakes", "Rivers", "Mountains"]
///
///     var body: some View {
///         List(landmarks) { landmark in
///             Text(landmark)
///                 .background(theme.backgroundSecondaryColor)
///         }
///     }
/// }
/// ```
///
/// **Deciding Darker Color Palette**
///
/// If parts of the app requires a certain screen to always be in darker mode
/// you should use the `preferredColorScheme(_:)` to force the presentation
/// color scheme to always be in `.dark` mode.
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
public struct Theme: Identifiable, MutableAppliable, UserInfoContainer {
    public typealias ID = Identifier<Self>
    public typealias ButtonColor = (ButtonIdentifier, ButtonState, ElementPosition) -> Color

    /// A unique id for the theme.
    public var id: ID

    /// A color that represents the system or application tint color.
    public var tintColor: Color

    /// The color for divider lines that hides any underlying content.
    public var separatorColor: Color

    /// The color for border lines that hides any underlying content.
    public var borderColor: Color

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public var toggleColor: Color

    /// The color for links.
    public var linkColor: Color

    /// The color for placeholder text in controls or text views.
    public var placeholderTextColor: Color

    // MARK: - Sentiment Color

    /// The color for representing positive sentiment.
    ///
    /// Use sentiment colors for items that represent positive, neutral or negative
    /// outcomes.
    ///
    /// Use this color to for outcomes, such as the validation succeeded.
    public var positiveSentimentColor: Color

    /// The color for representing neutral sentiment.
    ///
    /// Use sentiment colors for items that represent positive, neutral or negative
    /// outcomes.
    public var neutralSentimentColor: Color

    /// The color for representing negative sentiment.
    ///
    /// Use sentiment colors for items that represent positive, neutral or negative
    /// outcomes.
    ///
    /// Use this color to for outcomes, such as the validation failed or require
    /// user's attention.
    public var negativeSentimentColor: Color

    // MARK: - Text

    /// The color for text labels that contain primary content.
    public var textColor: Color

    /// The color for text labels that contain secondary content.
    public var textSecondaryColor: Color

    /// The color for text labels that contain tertiary content.
    public var textTertiaryColor: Color

    /// The color for text labels that contain quaternary content.
    public var textQuaternaryColor: Color

    // MARK: - Background

    /// The color for the main background of your interface.
    public var backgroundColor: Color

    /// The color for content layered on top of the main background.
    public var backgroundSecondaryColor: Color

    /// The color for content layered on top of secondary backgrounds.
    public var backgroundTertiaryColor: Color

    // MARK: - Grouped Background

    /// The color for the main background of your grouped interface.
    public var groupedBackgroundColor: Color

    /// The color for content layered on top of the main background of your grouped
    /// interface.
    public var groupedBackgroundSecondaryColor: Color

    /// The color for content layered on top of secondary backgrounds of your
    /// grouped interface.
    public var groupedBackgroundTertiaryColor: Color

    // MARK: - Button

    public var buttonTextColor: ButtonColor
    public var buttonBackgroundColor: ButtonColor

    // MARK: - Toolbar

    public var toolbarColorScheme: ColorScheme?

    /// Additional info which may be used to describe the theme further.
    public var userInfo: UserInfo

    public init(
        id: ID,
        tintColor: Color,
        separatorColor: Color,
        borderColor: Color,
        toggleColor: Color,
        linkColor: Color,
        placeholderTextColor: Color,

        // Sentiment
        positiveSentimentColor: Color,
        neutralSentimentColor: Color,
        negativeSentimentColor: Color,

        // Text
        textColor: Color,
        textSecondaryColor: Color,
        textTertiaryColor: Color,
        textQuaternaryColor: Color,

        // Background
        backgroundColor: Color,
        backgroundSecondaryColor: Color,
        backgroundTertiaryColor: Color,

        // Grouped Background
        groupedBackgroundColor: Color,
        groupedBackgroundSecondaryColor: Color,
        groupedBackgroundTertiaryColor: Color,

        // Button
        buttonTextColor: @escaping ButtonColor,
        buttonBackgroundColor: @escaping ButtonColor,

        // Toolbar
        toolbarColorScheme: ColorScheme? = nil,

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
        self.neutralSentimentColor = neutralSentimentColor
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

        // Toolbar
        self.toolbarColorScheme = toolbarColorScheme

        // UserInfo
        self.userInfo = userInfo
    }
}

// MARK: - Convenience

extension Theme {
    public func buttonBackgroundColor(_ id: ButtonIdentifier, _ state: ButtonState = .normal) -> Color {
        buttonBackgroundColor(id, state, .primary)
    }

    public func buttonTextColor(_ id: ButtonIdentifier, _ state: ButtonState = .normal) -> Color {
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
