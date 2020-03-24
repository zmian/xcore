//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - IDs

extension Identifier where Type == Theme {
    public static var `default`: Self { #function }
}

// MARK: - Theme

public struct Theme: Themable, Equatable {
    /// A unique id for the theme.
    public var id: Identifier<Self> = .default

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
        id: Identifier<Theme> = .default,
        isDark: Bool? = nil,
        tintColor: UIColor = .systemTint,
        separatorColor: UIColor = .lightGray,
        toggleColor: UIColor = .green,
        linkColor: UIColor = .systemTint,
        textColor: UIColor = .black,
        textColorSecondary: UIColor = .lightText,
        placeholderTextColor: UIColor = .lightGray,
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
        chrome: Chrome.Style = .blurred
    ) {
        self.id = id
        self.isDark = isDark ?? false
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.textColor = textColor
        self.textColorSecondary = textColorSecondary
        self.placeholderTextColor = placeholderTextColor
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
        self.chrome = chrome
    }
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    public static var current: Theme = .default

    public static var `default`: Theme = .init()
}

// MARK: - UIView

extension UIView {
    /// Called when the app theme property changes.
    ///
    /// In your implementation, refresh the view rendering as needed.
    @objc open func themeDidChange() { }
}

public protocol Themable {
    /// A unique id for the theme.
    var id: Identifier<Self> { get }
    
    /// A boolean value indicating whether the theme appearance is dark.
    var isDark: Bool { get }

    /// The main brand color for interface callout content.
    var tintColor: UIColor { get }
    
    /// The color for borders or divider lines that hide any underlying content.
    var separatorColor: UIColor { get }
    
    /// The color for toggle controls (e.g., Switch or Checkbox).
    var toggleColor: UIColor { get }
    
    /// The color for links.
    var linkColor: UIColor { get }

    // MARK: - Text

    /// The color for text labels containing primary content.
    var textColor: UIColor { get }
    
    /// The color for text labels containing secondary content.
    var textColorSecondary: UIColor { get }

    /// The color to use for placeholder text in controls or text views.
    var placeholderTextColor: UIColor { get }
    
    /// The color to use for text in header cells in table views and outline views.
    var headerTextColor: UIColor { get }
    
    // MARK: - Background
    
    /// The color for the main background of your interface.
    var backgroundColor: UIColor { get }
    
    /// The color for background of seconday views.
    var backgroundColorSecondary: UIColor { get }
    
    /// The color for background of highlighted content and selected views
    var highglightedBackgroundColor: UIColor { get }
    
    /// The color for background of disabled content and views
    var disabledBackgroundColor: UIColor { get }
    
    // MARK: - Buttons
    var buttonTextColor: UIColor { get }
    
    var buttonBackgroundColor: UIColor { get }
    
    var buttonBackgroundColorSecondary: UIColor { get }
    
    var buttonBackgroundColorPill: UIColor { get }
    
    var statusBarStyle: UIStatusBarStyle { get }
    
    var chrome: Chrome.Style { get }
}

extension Themable {
    public var isDark: Bool {
        false
    }
    
    public var tintColor: UIColor {
        .systemTint
    }
    
    public var separatorColor: UIColor {
        .lightGray
    }
    
    public var toggleColor: UIColor {
        .green
    }

    public var linkColor: UIColor {
        .systemTint
    }

    public var textColor: UIColor {
        .black
    }

    public var textColorSecondary: UIColor {
        .lightText
    }
    
    public var placeholderTextColor: UIColor {
        .lightGray
    }
    
    public var headerTextColor: UIColor {
        .lightGray
    }
    
    public var backgroundColor: UIColor {
        .white
    }
    
    public var backgroundColorSecondary: UIColor {
        .lightGray
    }
    
    public var highglightedBackgroundColor: UIColor {
        .lightGray
    }
    
    public var disabledBackgroundColor: UIColor {
        .darkGray
    }
    
    public var buttonTextColor: UIColor {
        .white
    }
    
    public var buttonBackgroundColor: UIColor {
        .systemTint
    }
    
    public var buttonBackgroundColorSecondary: UIColor {
        .lightGray
    }
    
    public var buttonBackgroundColorPill: UIColor {
        .systemTint
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        .default
    }
    
    public var chrome: Chrome.Style {
        .blurred
    }
}
