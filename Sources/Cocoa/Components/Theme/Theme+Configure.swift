//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Theme {
    /// A method to set system components default appearance using the given theme.
    ///
    /// - Parameter theme: The theme to set.
    public static func set(_ theme: Theme) {
        self.default = theme
        setSystemComponentsTheme(theme)
        setNavigationBarBackButtonTheme(theme)
        setSearchBarTheme(theme)
        setComponentsTheme(theme)
    }

    private static func setSystemComponentsTheme(_ theme: Theme) {
        UIApplication.sharedOrNil?.delegate?.window??.tintColor = theme.accentColor
        UIBarButtonItem.appearance().setTitleTextAttributes(UIViewController.defaultNavigationBarTextAttributes, for: .normal)

        UINavigationBar.appearance().apply {
            $0.titleTextAttributes = UIViewController.defaultNavigationBarTextAttributes
            $0.tintColor = theme.accentColor
            $0.barTintColor = theme.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = theme.accentColor
            $0.barTintColor = theme.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = .systemGray6
            $0.currentPageIndicatorTintColor = theme.accentColor
            $0.backgroundColor = .clear
        }

        UISwitch.appearance().apply {
            $0.tintColor = theme.textColor.alpha(0.08)
            $0.onTintColor = theme.toggleColor
        }

        UISlider.appearance().apply {
            $0.maximumTrackTintColor = theme.textColor.alpha(0.16)
        }

        UITabBar.appearance().apply {
            $0.tintColor = theme.accentColor
            $0.borderColor = theme.separatorColor
            $0.borderWidth = .onePixel
        }
    }

    private static func setNavigationBarBackButtonTheme(_ theme: Theme) {
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).apply {
            $0.backIndicatorImage = UIImage(assetIdentifier: .navigationBarBackArrow)
            $0.backIndicatorTransitionMaskImage = UIImage(assetIdentifier: .navigationBarBackArrow)
        }

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [NavigationController.self])
            .setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .default)
    }

    private static func setSearchBarTheme(_ theme: Theme) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).apply {
            // SearchBar Cancel button normal state
             $0.setTitleTextAttributes([
                .foregroundColor: theme.accentColor,
                .font: UIFont.app(.body)
            ], for: .normal)

            // SearchBar Cancel button disabled state
            $0.setTitleTextAttributes([
                .foregroundColor: theme.accentColor.alpha(0.5)
            ], for: .disabled)
        }

        // SearchBar text attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: theme.textColor,
            .font: UIFont.app(.body)
        ]

        UISearchBar.appearance().placeholderTextColor = theme.textColor.alpha(0.5)
    }

    private static func setComponentsTheme(_ theme: Theme) {
        BlurView.appearance().blurOpacity = 0.8

        SeparatorView.appearance().tintColor = theme.separatorColor

        UIViewController.defaultAppearance.apply {
            $0.tintColor = theme.accentColor
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
                $0[.base].textColor = theme.linkColor
                $0[.base].tintColor = theme.accentColor

                $0[.callout].textColor = .label
                $0[.callout].backgroundColor = theme.buttonBackgroundColor(.fill, .primary)
                $0[.calloutSecondary].backgroundColor = theme.buttonBackgroundColor(.fill, .secondary)
                $0[.pill].backgroundColor = theme.buttonBackgroundColor(.pill, .primary)

                // Toggle Styles
                $0[.checkbox].font = .app(.caption2)
                $0[.checkbox].tintColor = theme.toggleColor
                $0[.radioButton].tintColor = theme.toggleColor
            }
        }
    }
}
