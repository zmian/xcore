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
    public static var `default`: Self { #function }
}

// MARK: - Theme

public struct Theme: Equatable {
    /// A unique id for the theme.
    public let id: Identifier<Self>

    /// The main brand color for interface callout content.
    public let tintColor: UIColor

    /// The color for borders or divider lines that hide any underlying content.
    public let separatorColor: UIColor

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public let toggleColor: UIColor

    /// The color for links.
    public let linkColor: UIColor
    
//    /// The color to use for background of header cells in table views and outline views.
//    public let headerBackgoundColor: UIColor

    // MARK: - Text

    /// The color for text labels containing primary content.
    public let textColor: UIColor

    /// The color for text labels containing secondary content.
    public let textColorSecondary: UIColor
    
    /// The color to use for placeholder text in controls or text views.
    public let placeholderTextColor: UIColor
    
    /// The color to use for text in header cells in table views and outline views.
    public let headerTextColor: UIColor

    // MARK: - Background
    
    /// The color for the main background of your interface.
    public let backgroundColor: UIColor
    
    /// The color for background of seconday views.
    public let backgroundColorSecondary: UIColor
    
    /// Add description
    public let highglightedBackgroundColor: UIColor
    
    /// Add description
    public let disabledBackgroundColor: UIColor

    // MARK: - Buttons
    public let buttonTextColor: UIColor
    public let buttonBackgroundColor: UIColor
    public let buttonBackgroundColorSecondary: UIColor
    public let buttonBackgroundColorPill: UIColor
    public let statusBarStyle: UIStatusBarStyle
    public let chrome: Chrome.Style

    public init(
        id: Identifier<Theme>,
        tintColor: UIColor,
        separatorColor: UIColor,
        toggleColor: UIColor,
        linkColor: UIColor,
        textColor: UIColor,
        textColorSecondary: UIColor,
        placeholderTextColor: UIColor,
        headerTextColor: UIColor,
        backgroundColor: UIColor,
        backgroundColorSecondary: UIColor,
        highglightedBackgroundColor: UIColor,
        disabledBackgroundColor: UIColor,
        buttonTextColor: UIColor,
        buttonBackgroundColor: UIColor,
        buttonBackgroundColorSecondary: UIColor,
        buttonBackgroundColorPill: UIColor,
        statusBarStyle: UIStatusBarStyle,
        chrome: Chrome.Style? = nil
    ) {
        self.id = id
        self.tintColor = tintColor
        self.separatorColor = separatorColor
        self.toggleColor = toggleColor
        self.linkColor = linkColor
        self.textColor = textColor
        self.textColorSecondary = textColorSecondary
        self.placeholderTextColor = placeholderTextColor
        self.headerTextColor = headerTextColor
        self.backgroundColor = backgroundColor
        self.buttonTextColor = buttonTextColor
        self.buttonBackgroundColor = buttonBackgroundColor
        self.backgroundColorSecondary = backgroundColorSecondary
        self.highglightedBackgroundColor = highglightedBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.buttonBackgroundColorSecondary = buttonBackgroundColorSecondary
        self.buttonBackgroundColorPill = buttonBackgroundColorPill
        self.statusBarStyle = statusBarStyle
        self.chrome = .color(backgroundColor)
    }
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    internal(set) public static var current: Theme = .default

    #warning("TODO: Fix the defaults so it matches the system defaults")
    internal(set) public static var `default`: Theme = .init(
        id: .default,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        toggleColor: .yellow,
        linkColor: .systemTint,
        textColor: .purple,
        textColorSecondary: .lightGray,
        placeholderTextColor: .red,
        headerTextColor: .black,
        backgroundColor: .purple,
        backgroundColorSecondary: .red,
        highglightedBackgroundColor: .red,
        disabledBackgroundColor: .red,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
        statusBarStyle: .default
    )
}

// MARK: - UIView

extension UIView {
    /// Called when the app theme property changes.
    ///
    /// In your implementation, refresh the view rendering as needed.
    @objc open func themeDidChange() { }
}
