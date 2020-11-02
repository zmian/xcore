//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
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
    ///   - theme: The default value is `.current`.
    /// - Returns: `true` if first call; otherwise, `false`.
    @discardableResult
    public static func set(theme: Theme) -> Bool {
        guard !didSet else {
            return false
        }

        didSet = true
        self.current = theme

        setSystemComponentsTheme()
        setNavigationBarBackButtonTheme()
        setSearchBarTheme()
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
            $0.barTintColor = current.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = current.tintColor
            $0.barTintColor = current.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = false
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = .appleGray
            $0.currentPageIndicatorTintColor = current.tintColor
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
                .font: UIFont.app(.body)
            ], for: .normal)

            // SearchBar Cancel button disabled state
            $0.setTitleTextAttributes([
                .foregroundColor: current.tintColor.alpha(0.5)
            ], for: .disabled)
        }

        // SearchBar text attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: current.textColor,
            .font: UIFont.app(.body)
        ]

        UISearchBar.appearance().placeholderTextColor = current.textColor.alpha(0.5)
    }

    private static func setComponentsTheme() {
        BlurView.appearance().blurOpacity = 0.8

        SeparatorView.appearance().tintColor = current.separatorColor

        UIViewController.defaultAppearance.apply {
            $0.tintColor = current.tintColor
            $0.prefersTabBarHidden = true
        }

        UIButton.defaultAppearance.apply {
            $0.configuration = .callout
            $0.height = AppConstants.uiControlsHeight
            $0.isHeightSetAutomatically = true
            $0.highlightedAnimation = .scale
            $0.configurationAttributes.apply {
                // Styles Updates
                $0[.base].font = .app(.body)
                $0[.base].textColor = current.buttonTextColor
                $0[.base].tintColor = current.tintColor

                $0[.callout].textColor = current.buttonTextColor
                $0[.callout].backgroundColor = current.buttonBackgroundColor
                $0[.calloutSecondary].backgroundColor = current.buttonBackgroundColorSecondary
                $0[.pill].backgroundColor = current.buttonBackgroundColorPill

                // Toggle Styles
                $0[.checkbox].font = .app(.caption2)
                $0[.checkbox].tintColor = current.toggleColor
                $0[.radioButton].tintColor = current.toggleColor
            }
        }

        LabelTextView.appearance().apply {
            $0.linkTextAttributes = [.foregroundColor: current.linkColor]
            $0.textColor = current.textColor
            $0.font = .app(.body)
        }
    }
}
