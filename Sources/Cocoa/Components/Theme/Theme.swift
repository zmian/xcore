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

public struct Theme: Themable, Equatable {
//    /// A unique id for the theme.
//    public let id: Identifier<Self>
//
    /// The main brand color for interface callout content.
    public var tintColor: UIColor
    
    /// The color for borders or divider lines that hide any underlying content.
    public var separatorColor: UIColor

    /// The color for toggle controls (e.g., Switch or Checkbox).
    public var toggleColor: UIColor

    /// The color for links.
    public var linkColor: UIColor
    
////    /// The color to use for background of header cells in table views and outline views.
////    public let headerBackgoundColor: UIColor
//
//    // MARK: - Text

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
    
    /// Add description
    public var highglightedBackgroundColor: UIColor
    
    /// Add description
    public var disabledBackgroundColor: UIColor

    // MARK: - Buttons
    public var buttonTextColor: UIColor
    public var buttonBackgroundColor: UIColor
    public var buttonBackgroundColorSecondary: UIColor
    public var buttonBackgroundColorPill: UIColor
    public var statusBarStyle: UIStatusBarStyle
    public var chrome: Chrome.Style
}

// MARK: - Default

extension Theme {
    /// The current theme for the interface.
    internal(set) public static var current: Theme = .default

    #warning("TODO: Fix the defaults so it matches the system defaults")
    internal(set) public static var `default`: Theme = .init(
//        id: .default,
        tintColor: .systemTint,
        separatorColor: .lightGray,
        toggleColor: .yellow,
        linkColor: .systemTint,
        textColor: .purple,
        textColorSecondary: .lightGray,
        placeholderTextColor: .red,
        headerTextColor: .black,
        backgroundColor: .white,
        backgroundColorSecondary: .red,
        highglightedBackgroundColor: .red,
        disabledBackgroundColor: .red,
        buttonTextColor: .systemTint,
        buttonBackgroundColor: .systemTint,
        buttonBackgroundColorSecondary: .systemTint,
        buttonBackgroundColorPill: .systemTint,
        statusBarStyle: .default,
        chrome: .blurred
    )
}

// MARK: - UIView

extension UIView {
    /// Called when the app theme property changes.
    ///
    /// In your implementation, refresh the view rendering as needed.
    @objc open func themeDidChange() { }
}

public protocol Themable {
//    /// A unique id for the theme.
//    var id: Identifier<Self> { get }

    /// The main brand color for interface callout content.
    var tintColor: UIColor { get }
    
    /// The color for borders or divider lines that hide any underlying content.
    var separatorColor: UIColor { get }
    
    /// The color for toggle controls (e.g., Switch or Checkbox).
    var toggleColor: UIColor { get }
    
    /// The color for links.
    var linkColor: UIColor { get }
//
//    //    /// The color to use for background of header cells in table views and outline views.
//    //    public let headerBackgoundColor: UIColor
//
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
    
    /// Add description
    var highglightedBackgroundColor: UIColor { get }
    
    /// Add description
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
    #warning("TODO: Fix the defaults so it matches the system defaults")

    public var tintColor: UIColor {
        .green
    }
    
    public var separatorColor: UIColor {
        .green
    }
    
    public var toggleColor: UIColor {
        .green
    }

    public var linkColor: UIColor {
        .green
    }

    public var textColor: UIColor {
        .green
    }

    public var textColorSecondary: UIColor {
        .green
    }
    
    public var placeholderTextColor: UIColor {
        .green
    }
    
    public var headerTextColor: UIColor {
        .green
    }
    
    public var backgroundColor: UIColor {
        .green
    }
    
    public var backgroundColorSecondary: UIColor {
        .green
    }
    
    public var highglightedBackgroundColor: UIColor {
        .green
    }
    
    public var disabledBackgroundColor: UIColor {
        .green
    }
    
    public var buttonTextColor: UIColor {
        .green
    }
    
    public var buttonBackgroundColor: UIColor {
        .green
    }
    
    public var buttonBackgroundColorSecondary: UIColor {
        .green
    }
    
    public var buttonBackgroundColorPill: UIColor {
        .green
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        .default
    }
    
    public var chrome: Chrome.Style {
        .blurred
    }
}

