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

    /// A method to set light and dark theme.
    ///
    /// - Note: This method can only be called once. Any subsequent calls will be
    /// ignored.
    ///
    /// - Parameters:
    ///   - light: The nonadaptable light theme for the interface.
    ///   - dark: The nonadaptable dark theme for the interface.
    ///   - current: The current theme. The default value is `.light`.
    /// - Returns: `true` if first call; otherwise, `false`.
    @discardableResult
    public static func set(light: Theme, dark: Theme, current: Theme? = nil) -> Bool {
        guard !didSet else {
            return false
        }

        didSet = true

        self.light = light
        self.dark = dark
        self.current = current ?? light

        setSystemComponentsTheme()
        setNavigationBarBackButtonTheme()
        setSearchBarTheme()
        setDynamicTableViewTheme()
        setComponentsTheme()
        return true
    }

    private static func setSystemComponentsTheme() {
        UIColor.appTint = current.tintColor
        UIColor.appSeparator = current.separatorColor

        UIApplication.sharedOrNil?.delegate?.window??.tintColor = current.tintColor
        UIBarButtonItem.appearance().setTitleTextAttributes(UIViewController.defaultNavigationBarTextAttributes, for: .normal)

        UINavigationBar.appearance().apply {
            $0.titleTextAttributes = UIViewController.defaultNavigationBarTextAttributes
            $0.tintColor = current.tintColor
            $0.barTintColor = .white
            $0.barStyle = .black
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = current.tintColor
            $0.barTintColor = .white
            $0.barStyle = .black
            $0.isTranslucent = true
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = current.tintColor
            $0.currentPageIndicatorTintColor = current.toggleColor
            $0.backgroundColor = .clear
        }

        UISwitch.appearance().apply {
            $0.tintColor = current.textColor.alpha(0.08)
            $0.onTintColor = current.toggleColor
        }

        UISlider.appearance().apply {
            $0.maximumTrackTintColor = current.textColor.alpha(0.16)
        }

        UITabBar.appearance().apply {
            $0.tintColor = current.tintColor
            $0.borderColor = current.separatorColor
            $0.borderWidth = .onePixel
        }
    }

    private static func setNavigationBarBackButtonTheme() {
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).apply {
            $0.backIndicatorImage = UIImage(assetIdentifier: .navigationBarBackArrow)
            $0.backIndicatorTransitionMaskImage = UIImage(assetIdentifier: .navigationBarBackArrow)
        }

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [NavigationController.self])
            .setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .default)
    }

    private static func setSearchBarTheme() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).apply {
            // SearchBar Cancel button normal state
             $0.setTitleTextAttributes([
                .foregroundColor: current.tintColor,
                .font: UIFont.app(style: .body)
            ], for: .normal)

            // SearchBar Cancel button disabled state
            $0.setTitleTextAttributes([
                .foregroundColor: current.tintColor.alpha(0.5)
            ], for: .disabled)
        }

        // SearchBar text attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: current.textColor,
            .font: UIFont.app(style: .body)
        ]

        UISearchBar.appearance().placeholderTextColor = current.textColor.alpha(0.5)
    }

    private static func setDynamicTableViewTheme() {
        // MARK: DynamicTableView
        DynamicTableView.appearance().apply {
            $0.headerFont = .app(style: .caption1)
            $0.headerTextColor = current.textColor
            $0.footerFont = .app(style: .caption1)
            $0.footerTextColor = current.textColorSecondary
            $0.accessoryFont = .app(style: .subheadline)
            $0.accessoryTextColor = current.textColorSecondary
            $0.accessoryTintColor = current.tintColor
            $0.checkboxOffTintColor = current.separatorColor
            $0.separatorColor = current.separatorColor
            $0.rowActionDeleteColor = .appleRed
            $0.isEmptyCellsHidden = true
        }

        DynamicTableViewCell.appearance().apply {
            $0.titleTextColor = current.textColor
            $0.subtitleTextColor = current.textColorSecondary
            $0.contentInset = UIEdgeInsets(top: 9, left: 15, bottom: 10, right: 15)
            $0.textImageSpacing = .defaultPadding
        }

        IconLabelView.appearance().apply {
            $0.titleTextColor = current.textColor
            $0.subtitleTextColor = current.textColorSecondary
        }

        BlurView.appearance().blurOpacity = 0.8
    }

    private static func setComponentsTheme() {
        SeparatorView.appearance().tintColor = current.separatorColor

        #if canImport(Haring)
        MarkupText.appearance.apply {
            $0.textColor = current.textColor
        }
        #endif

        UIViewController.defaultAppearance.apply {
            $0.tintColor = current.tintColor
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
            $0.styleAttributes.style(.base).setTextColor(current.buttonTextColor)
            $0.styleAttributes.style(.base).setTintColor(current.tintColor)

            $0.styleAttributes.style(.callout).setTextColor(.white)
            $0.styleAttributes.style(.callout).setBackgroundColor(current.buttonBackgroundColor)
            $0.styleAttributes.style(.calloutSecondary).setBackgroundColor(current.buttonBackgroundColorSecondary)
            $0.styleAttributes.style(.pill).setBackgroundColor(current.buttonBackgroundColorPill)

            // Toggle Styles
            $0.styleAttributes.style(.checkbox).setFont(.app(style: .caption2))
            $0.styleAttributes.style(.checkbox).setTintColor(current.toggleColor)
            $0.styleAttributes.style(.radioButton).setTintColor(current.toggleColor)
        }

        LabelTextView.appearance().apply {
            $0.linkTextAttributes = [.foregroundColor: current.linkColor]
            $0.textColor = current.textColor
            $0.font = .app(style: .body)
        }

        Picker.RowView.appearance().apply {
            $0.titleTextColor = current.textColor
            $0.subtitleTextColor = current.textColorSecondary
        }
    }
}
