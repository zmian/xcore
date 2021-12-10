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

    private static func setComponentsTheme(_ theme: Theme) {
        BlurView.appearance().blurOpacity = 0.8

        SeparatorView.appearance().tintColor = theme.separatorColor

        UIViewController.defaultAppearance.apply {
            $0.tintColor = theme.tintColor
        }
    }
}
