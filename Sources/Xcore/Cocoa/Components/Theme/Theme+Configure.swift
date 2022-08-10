//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

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
        let tintColor = theme.tintColor.uiColor

        UIApplication.sharedOrNil?.delegate?.window??.tintColor = tintColor

        UIBarButtonItem.appearance().setTitleTextAttributes(
            UIViewController.defaultBarButtonItemTextAttributes,
            for: .normal
        )

        UINavigationBar.appearance().apply {
            $0.titleTextAttributes = UIViewController.defaultNavigationBarTextAttributes
            $0.tintColor = tintColor
            $0.barTintColor = theme.backgroundColor.uiColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIToolbar.appearance().apply {
            $0.tintColor = tintColor
            $0.barTintColor = theme.backgroundColor.uiColor
            $0.barStyle = .default
            $0.isTranslucent = true
        }

        UIPageControl.appearance().apply {
            $0.pageIndicatorTintColor = .systemGray6
            $0.currentPageIndicatorTintColor = tintColor
            $0.backgroundColor = .clear
        }

        UISwitch.appearance().apply {
            $0.tintColor = theme.textColor.opacity(0.08).uiColor
            $0.onTintColor = theme.toggleColor.uiColor
        }

        UISlider.appearance().apply {
            $0.maximumTrackTintColor = theme.textColor.opacity(0.16).uiColor
        }

        UITabBar.appearance().apply {
            $0.tintColor = tintColor
            $0.borderColor = theme.separatorColor.uiColor
            $0.borderWidth = .onePixel
        }
    }

    private static func setComponentsTheme(_ theme: Theme) {
        BlurView.appearance().blurOpacity = 0.8

        SeparatorView.appearance().tintColor = theme.separatorColor.uiColor

        UIViewController.defaultAppearance.apply {
            $0.tintColor = theme.tintColor.uiColor
        }
    }
}
