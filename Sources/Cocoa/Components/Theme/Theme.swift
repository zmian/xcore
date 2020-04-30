//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - IDs

extension Identifier where Type == Theme {
    public static var current: Self { #function }
}

// MARK: - Theme

public struct Theme: Equatable {
    /// A unique id for the theme.
    public var id: Identifier<Self> = .current

    /// A boolean value indicating whether the theme appearance is dark.
    public var isDark: Bool

    /// The main brand color for interface callout content.
    public var tintColor: UIColor

    /// The color for borders or divider lines that hide any underlying content.
    public var separatorColor: UIColor

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public var toggleColor: UIColor

    /// The color for links.
    public var linkColor: UIColor

    // MARK: - Text

    /// The color for text labels containing primary content.
    public var textColor: UIColor

    /// The color for text labels containing secondary content.
    public var textColorSecondary: UIColor

    /// The color to use for placeholder text in controls or text views.
    public var placeholderTextColor: UIColor
    
    /// The color to use for text in text views.
    public var textFieldTextColor: UIColor

    /// The color to use for text in header cells in table views and outline views.
    public var headerTextColor: UIColor

    // MARK: - Background
    
    /// The color for the main background of your interface.
    public var backgroundColor: UIColor

    /// The color for background of seconday views.
    public var backgroundColorSecondary: UIColor

    /// The color for background of highlighted content and selected views
    public var highglightedBackgroundColor: UIColor

    /// The color for background of disabled content and views
    public var disabledBackgroundColor: UIColor

    // MARK: - Buttons

    public var buttonTextColor: UIColor
    public var buttonBackgroundColor: UIColor
    public var buttonBackgroundColorSecondary: UIColor
    public var buttonBackgroundColorPill: UIColor

    public var statusBarStyle: UIStatusBarStyle
    public var chrome: Chrome.Style

    public init(
        id: Identifier<Theme> = .current,
        isDark: Bool? = nil,
        tintColor: UIColor = .systemTint,
        separatorColor: UIColor = .lightGray,
        toggleColor: UIColor = .green,
        linkColor: UIColor = .systemTint,
        textColor: UIColor = .black,
        textColorSecondary: UIColor = .darkGray,
        placeholderTextColor: UIColor = .lightGray,
        textFieldTextColor: UIColor = .darkGray,
        headerTextColor: UIColor = .lightGray,
        backgroundColor: UIColor = .white,
        backgroundColorSecondary: UIColor = .lightGray,
        highglightedBackgroundColor: UIColor = .lightGray,
        disabledBackgroundColor: UIColor = .darkGray,
        buttonTextColor: UIColor = .white,
        buttonBackgroundColor: UIColor = .systemTint,
        buttonBackgroundColorSecondary: UIColor = .lightGray,
        buttonBackgroundColorPill: UIColor = .systemTint,
        statusBarStyle: UIStatusBarStyle = .default,
        chrome: Chrome.Style? = nil
    ) {
        let isDarkContent = isDark ?? false
        self.id = id
        self.isDark = isDarkContent
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.textColor = textColor
        self.textColorSecondary = textColorSecondary
        self.placeholderTextColor = placeholderTextColor
        self.textFieldTextColor = textFieldTextColor
        self.headerTextColor = headerTextColor
        self.backgroundColor = backgroundColor
        self.backgroundColorSecondary = backgroundColorSecondary
        self.highglightedBackgroundColor = highglightedBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonBackgroundColorSecondary = buttonBackgroundColorSecondary
        self.buttonBackgroundColorPill = buttonBackgroundColorPill
        self.statusBarStyle = statusBarStyle
        self.chrome = chrome ?? (isDarkContent ? .color(backgroundColor) : .blurred)
    }
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    public static var current: Theme = _current

    private static var _current: Theme {
        guard #available(iOS 13, *) else {
            return systemTheme
        }
        return dynamicSystemTheme
    }
}

// MARK: - UIView

extension UIView {
    /// Called when the app theme property changes.
    ///
    /// In your implementation, refresh the view rendering as needed.
    @objc open func themeDidChange() { }
}

extension Theme {
    public static var systemTheme: Theme = .init(
        id: .current,
        isDark: false,
        tintColor: .systemTint,
        separatorColor: .appSeparator,
        toggleColor: .green,
        linkColor: .systemTint,
        textColor: .black,
        textColorSecondary: .darkGray,
        placeholderTextColor: .lightGray,
        textFieldTextColor: .darkGray,
        headerTextColor: .lightGray,
        backgroundColor: .white,
        backgroundColorSecondary: .lightGray,
        highglightedBackgroundColor: .lightGray,
        disabledBackgroundColor: .darkGray,
        buttonTextColor: .white,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .lightGray,
        buttonBackgroundColorPill: .systemTint,
        statusBarStyle: .default,
        chrome: .blurred
    )

    @available(iOS 13, *)
    public static var dynamicSystemTheme: Theme = .init(
        id: .current,
        isDark: false,
        tintColor: .link,
        separatorColor: .separator,
        toggleColor: .systemGreen,
        linkColor: .link,
        textColor: .label,
        textColorSecondary: .secondaryLabel,
        placeholderTextColor: .placeholderText,
        textFieldTextColor: .placeholderText,
        headerTextColor: .systemGray,
        backgroundColor: .systemBackground,
        backgroundColorSecondary: .systemGray,
        highglightedBackgroundColor: .systemGray,
        disabledBackgroundColor: .darkGray,
        buttonTextColor: .systemBackground,
        buttonBackgroundColor: .link,
        buttonBackgroundColorSecondary: .systemGray,
        buttonBackgroundColorPill: .systemTint,
        statusBarStyle: .default,
        chrome: Chrome.Style.color(.systemBackground))
}
