//
// Theme+Configure.swift
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

extension Theme {
    private static var didSet = false

    private static var app: Theme {
        return .default
    }

    /// A method to set light and dark theme.
    ///
    /// - Note: This method can only be called once. Any subsequent calls will be
    /// ignored.
    ///
    /// - Parameters:
    ///   - light: The nonadaptable light theme for the interface.
    ///   - dark: The nonadaptable dark theme for the interface.
    ///   - default: The default theme. The default value is `.light`.
    /// - Returns: `true` if first call; otherwise, `false`.
    @discardableResult
    public static func set(light: Theme, dark: Theme, default: Theme? = nil) -> Bool {
        guard !didSet else {
            return false
        }

        didSet = true

        self.light = light
        self.dark = dark
        self.default = `default` ?? light

        setSystemComponentsTheme()
        setNavigationBarBackButtonTheme()
        setSearchBarTheme()
        setDynamicTableViewTheme()
        setComponentsTheme()
        return true
    }

    private static func setSystemComponentsTheme() {
        UIColor.appTint = app.tintColor
        UIColor.appSeparator = app.separatorColor

        UIApplication.sharedOrNil?.delegate?.window??.tintColor = app.tintColor
        UIBarButtonItem.appearance().setTitleTextAttributes(UIViewController.defaultNavigationBarTextAttributes, for: .normal)

        UINavigationBar.appearance().apply {
            $0.titleTextAttributes = UIViewController.defaultNavigationBarTextAttributes
            $0.tintColor = app.tintColor
            $0.barTintColor = .white
            $0.barStyle = .black
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = app.tintColor
            $0.barTintColor = .white
            $0.barStyle = .black
            $0.isTranslucent = true
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = app.tintColor
            $0.currentPageIndicatorTintColor = app.toggleColor
            $0.backgroundColor = .clear
        }

        UISwitch.appearance().apply {
            $0.tintColor = app.textColor.alpha(0.08)
            $0.onTintColor = app.toggleColor
        }

        UISlider.appearance().apply {
            $0.maximumTrackTintColor = app.textColor.alpha(0.16)
        }

        UITabBar.appearance().apply {
            $0.tintColor = app.tintColor
            $0.borderColor = app.separatorColor
            $0.borderWidth = .onePixel
        }
    }

    private static func setNavigationBarBackButtonTheme() {
        // NavigationBar Back button
        UINavigationBar.appearance().apply {
            $0.backIndicatorImage = UIImage(assetIdentifier: .navigationBarBackArrow)
            $0.backIndicatorTransitionMaskImage = UIImage(assetIdentifier: .navigationBarBackArrow)
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .default)
    }

    private static func setSearchBarTheme() {
        // SearchBar Cancel button normal state
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: app.tintColor,
            .font: UIFont.app(style: .body)
        ], for: .normal)

        // SearchBar Cancel button disabled state
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            .foregroundColor: app.tintColor.alpha(0.5)
        ], for: .disabled)

        // SearchBar text attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: app.textColor,
            .font: UIFont.app(style: .body)
        ]

        UISearchBar.appearance().placeholderTextColor = app.textColor.alpha(0.5)
    }

    private static func setDynamicTableViewTheme() {
        // MARK: DynamicTableView
        DynamicTableView.appearance().apply {
            $0.headerFont = .app(style: .caption1)
            $0.headerTextColor = app.textColorSecondary
            $0.footerFont = .app(style: .caption1)
            $0.footerTextColor = app.textColorSecondary
            $0.accessoryFont = .app(style: .callout)
            $0.accessoryTextColor = app.textColorSecondary
            $0.accessoryTintColor = app.tintColor
            $0.checkboxOffTintColor = app.separatorColor
            $0.separatorColor = app.separatorColor
            $0.rowActionDeleteColor = .appleRed
            $0.isEmptyCellsHidden = true
        }

        DynamicTableViewCell.appearance().apply {
            $0.titleTextColor = app.textColor
            $0.titleFont = .app(style: .body)
            $0.subtitleTextColor = app.textColorSecondary
            $0.subtitleFont = .app(style: .callout)
            $0.contentInset = UIEdgeInsets(top: 9, left: 15, bottom: 10, right: 15)
            $0.textImageSpacing = .defaultPadding
        }

        IconLabelView.appearance().apply {
            $0.titleTextColor = app.textColor
            $0.titleFont = .app(style: .body)
            $0.subtitleTextColor = app.textColorSecondary
            $0.subtitleFont = .app(style: .callout)
        }

        BlurView.appearance().blurOpacity = 0.8
    }

    private static func setComponentsTheme() {
        SeparatorView.appearance().backgroundColor = app.separatorColor

        MarkupText.appearance.apply {
            $0.textColor = app.textColor
        }

        UIViewController.defaultAppearance.apply {
            $0.tintColor = app.tintColor
            $0.font = .app(style: .body)
            $0.preferredNavigationBarBackground = .transparent
            $0.prefersTabBarHidden = true
        }

        UIButton.defaultAppearance.apply {
            $0.style = .callout
            $0.height = AppConstants.uiControlsHeight
            $0.isHeightSetAutomatically = true
            $0.highlightedAnimation = .scale
            // Styles Updates
            $0.styleAttributes.style(.base).setFont(.app(style: .body))
            $0.styleAttributes.style(.base).setTextColor(app.buttonTextColor)
            $0.styleAttributes.style(.base).setTintColor(app.tintColor)

            $0.styleAttributes.style(.callout).setTextColor(.white)
            $0.styleAttributes.style(.callout).setBackgroundColor(app.buttonBackgroundColor)
            $0.styleAttributes.style(.calloutSecondary).setBackgroundColor(app.buttonBackgroundColorSecondary)
            $0.styleAttributes.style(.pill).setBackgroundColor(app.buttonBackgroundColorPill)

            // Toggle Styles
            $0.styleAttributes.style(.checkbox).setFont(.app(style: .caption2))
            $0.styleAttributes.style(.checkbox).setTintColor(app.toggleColor)
            $0.styleAttributes.style(.radioButton).setTintColor(app.toggleColor)
        }

        LabelTextView.appearance().apply {
            $0.linkTextAttributes = [.foregroundColor: app.linkColor]
            $0.textColor = app.textColor
            $0.font = .app(style: .body)
        }

        Picker.RowView.appearance().apply {
            $0.titleTextColor = app.textColor
            $0.subtitleTextColor = app.textColorSecondary
        }
    }
}
