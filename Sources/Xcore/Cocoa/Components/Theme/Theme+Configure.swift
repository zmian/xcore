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
        UIApplication.sharedOrNil?.delegate?.window??.tintColor = theme.tintColor

        UIBarButtonItem.appearance().setTitleTextAttributes(
            UIViewController.defaultNavigationBarTextAttributes,
            for: .normal
        )

        UINavigationBar.appearance().apply {
            $0.titleTextAttributes = UIViewController.defaultNavigationBarTextAttributes
            $0.tintColor = theme.tintColor
            $0.barTintColor = theme.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = theme.tintColor
            $0.barTintColor = theme.backgroundColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = .systemGray6
            $0.currentPageIndicatorTintColor = theme.tintColor
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
            $0.tintColor = theme.tintColor
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
                .foregroundColor: theme.tintColor,
                .font: UIFont.app(.body)
            ], for: .normal)

            // SearchBar Cancel button disabled state
            $0.setTitleTextAttributes([
                .foregroundColor: theme.tintColor.alpha(0.5)
            ], for: .disabled)
        }

        // SearchBar text attributes
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            .foregroundColor: theme.textColor,
            .font: UIFont.app(.body)
        ]

        UISearchBar.appearance().placeholderTextColor = theme.placeholderTextColor
    }

    private static func setComponentsTheme(_ theme: Theme) {
        BlurView.appearance().blurOpacity = 0.8

        SeparatorView.appearance().tintColor = theme.separatorColor

        UIViewController.defaultAppearance.apply {
            $0.tintColor = theme.tintColor
            $0.prefersTabBarHidden = true
        }

        UIButton.defaultAppearance.apply {
            $0.highlightedAnimation = .scale
        }
    }
}
