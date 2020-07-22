//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - IDs

extension Identifier where Type == Theme {
    public static var light: Self { #function }
    public static var dark: Self { #function }
}

// MARK: - Theme

public struct Theme: Equatable {
    /// A unique id for the theme.
    public let id: Identifier<Self>

    /// A boolean value indicating whether the theme appearance is dark.
    public let isDark: Bool

    /// The main brand color for interface callout content.
    public let tintColor: UIColor

    /// The color for divider lines that hide any underlying content.
    public let separatorColor: UIColor

    /// The color for borders lines that hide any underlying content.
    public let borderColor: UIColor

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public let toggleColor: UIColor

    /// The color for links.
    public let linkColor: UIColor

    // MARK: - Text

    /// The color for text labels containing primary content.
    public let textColor: UIColor

    /// The color for text labels containing secondary content.
    public let textColorSecondary: UIColor

    /// The color for the main background of your interface.
    public let backgroundColor: UIColor

    // MARK: - Buttons
    public let buttonTextColor: UIColor
    public let buttonBackgroundColor: UIColor
    public let buttonBackgroundColorSecondary: UIColor
    public let buttonBackgroundColorPill: UIColor
    public let buttonSelectedBackgroundColor: UIColor
    public let statusBarStyle: UIStatusBarStyle
    public let chrome: Chrome.Style

    public init(
        id: Identifier<Theme>,
        dark: Bool? = nil,
        tintColor: UIColor,
        separatorColor: UIColor,
        borderColor: UIColor,
        toggleColor: UIColor,
        linkColor: UIColor,
        textColor: UIColor,
        textColorSecondary: UIColor,
        backgroundColor: UIColor,
        buttonTextColor: UIColor,
        buttonBackgroundColor: UIColor,
        buttonBackgroundColorSecondary: UIColor,
        buttonBackgroundColorPill: UIColor,
        buttonSelectedBackgroundColor: UIColor,
        statusBarStyle: UIStatusBarStyle,
        chrome: Chrome.Style? = nil
    ) {
        let isDark = dark ?? (id == .dark)
        self.id = id
        self.isDark = isDark
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.borderColor = borderColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.textColor = textColor
        self.textColorSecondary = textColorSecondary
        self.backgroundColor = backgroundColor
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonBackgroundColorSecondary = buttonBackgroundColorSecondary
        self.buttonBackgroundColorPill = buttonBackgroundColorPill
        self.buttonSelectedBackgroundColor = buttonSelectedBackgroundColor
        self.statusBarStyle = statusBarStyle
        self.chrome = chrome ?? (isDark ? .color(backgroundColor) : .blurred)
    }
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    internal(set) public static var current: Theme = .light

    /// The nonadaptable light theme for the interface.
    ///
    /// This theme does not adapt to changes in the underlying trait environment.
    internal(set) public static var light: Theme = .init(
        id: .light,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        borderColor: .lightGray,
        toggleColor: .systemTint,
        linkColor: .systemTint,
        textColor: .black,
        textColorSecondary: .lightGray,
        backgroundColor: .white,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
        buttonSelectedBackgroundColor: .systemTint,
        statusBarStyle: .default
    )

    /// The nonadaptable dark theme for the interface.
    ///
    /// This theme does not adapt to changes in the underlying trait environment.
    internal(set) public static var dark: Theme = .init(
        id: .dark,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        borderColor: .lightGray,
        toggleColor: .appleGreen,
        linkColor: .systemTint,
        textColor: .lightText,
        textColorSecondary: .lightGray,
        backgroundColor: .black,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
        buttonSelectedBackgroundColor: .systemTint,
        statusBarStyle: .lightContent
    )
}

// MARK: - UIView

extension UIView {
    /// Called when the app theme property changes.
    ///
    /// In your implementation, refresh the view rendering as needed.
    @objc open func themeDidChange() { }
}
