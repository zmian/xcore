//
// Theme.swift
//
// Copyright © 2016 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

// MARK: - IDs

extension Identifier where Type == Theme {
    public static var light: Identifier { return #function }
    public static var dark: Identifier { return #function }
}

// MARK: - Theme

public struct Theme: Equatable {
    /// A unique id for the theme.
    public let id: Identifier<Theme>

    /// A boolean value indicating whether the theme appearance is dark.
    public let isDark: Bool

    /// The main brand color for interface callout content.
    public let tintColor: UIColor

    /// The color for borders or divider lines that hide any underlying content.
    public let separatorColor: UIColor

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
    public let statusBarStyle: UIStatusBarStyle

    public init(
        id: Identifier<Theme>,
        dark: Bool? = nil,
        tintColor: UIColor,
        separatorColor: UIColor,
        toggleColor: UIColor,
        linkColor: UIColor,
        textColor: UIColor,
        textColorSecondary: UIColor,
        backgroundColor: UIColor,
        buttonTextColor: UIColor,
        buttonBackgroundColor: UIColor,
        buttonBackgroundColorSecondary: UIColor,
        buttonBackgroundColorPill: UIColor,
        statusBarStyle: UIStatusBarStyle
    ) {
        self.id = id
        self.isDark = dark ?? (id == .dark)
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.textColor = textColor
        self.textColorSecondary = textColorSecondary
        self.backgroundColor = backgroundColor
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonBackgroundColorSecondary = buttonBackgroundColorSecondary
        self.buttonBackgroundColorPill = buttonBackgroundColorPill
        self.statusBarStyle = statusBarStyle
    }
}

extension Theme {
    public var chrome: Chrome.Style {
        return isDark ? .color(backgroundColor) : .blurred
    }
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    internal(set) public static var current: Theme = .light

    /// The nonadaptable light theme for the interface.
    ///
    /// This theme does not adapt to changes in the underlying trait environment.
    internal(set) public static var light: Theme = Theme(
        id: .light,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        toggleColor: .systemTint,
        linkColor: .systemTint,
        textColor: .black,
        textColorSecondary: .lightGray,
        backgroundColor: .white,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
        statusBarStyle: .default
    )

    /// The nonadaptable dark theme for the interface.
    ///
    /// This theme does not adapt to changes in the underlying trait environment.
    internal(set) public static var dark: Theme = Theme(
        id: .dark,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        toggleColor: .appleGreen,
        linkColor: .systemTint,
        textColor: .lightText,
        textColorSecondary: .lightGray,
        backgroundColor: .black,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
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
