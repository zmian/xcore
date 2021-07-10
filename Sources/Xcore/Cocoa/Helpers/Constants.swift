//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import SwiftUI

// MARK: - Type Based Constants

extension TimeInterval {
    /// The fast duration to use for animations when the desired interval is between
    /// `0.2...0.3` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .fast) {
    ///     ...
    /// }
    /// ```
    public static var fast: Self = 0.25

    /// The default duration to use for animations when the desired interval is
    /// between `0.3...0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .`default) {
    ///     ...
    /// }
    /// ```
    public static var `default`: Self = 0.35

    /// The slow duration to use for animations when the desired interval is between
    /// `> 0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .slow) {
    ///     ...
    /// }
    /// ```
    public static var slow: Self = 0.5
}

extension CGAffineTransform {
    /// The default transform scale to use for animations when providing visual
    /// feedback when elements are highlighted.
    ///
    /// ```swift
    /// var isHighlighted = false {
    ///     didSet {
    ///         let transform: CGAffineTransform = isHighlighted ? .defaultScale : .identity
    ///         UIView.animateFromCurrentState {
    ///             self.transform = transform
    ///         }
    ///     }
    /// }
    /// ```
    public static var defaultScale: Self {
        .init(scaleX: 0.95, y: 0.95)
    }
}

// MARK: - CGFloat

extension CGFloat {
    /// Spacing with the default value of `4` at a normal dynamic type setting.
    public static var s1: Self = 4
    /// Spacing with the default value of `8` at a normal dynamic type setting.
    public static var s2: Self = 8
    /// Spacing with the default value of `12` at a normal dynamic type setting.
    public static var s3: Self = 12
    /// Spacing with the default value of `16` at a normal dynamic type setting.
    public static var s4: Self = 16
    /// Spacing with the default value of `24` at a normal dynamic type setting.
    public static var s5: Self = 24
    /// Spacing with the default value of `32` at a normal dynamic type setting.
    public static var s6: Self = 32

    /// A convenience method to return `1` pixel relative to the screen scale.
    public static var onePixel: Self {
        struct Static {
            static let onePixel = UIView().onePixel
        }

        return Static.onePixel
    }
}

// MARK: - UIEdgeInsets

extension UIEdgeInsets {
    /// Spacing with the default value of `4` at a normal dynamic type setting.
    public static var s1: Self { .init(.s1) }
    /// Spacing with the default value of `8` at a normal dynamic type setting.
    public static var s2: Self { .init(.s2) }
    /// Spacing with the default value of `12` at a normal dynamic type setting.
    public static var s3: Self { .init(.s3) }
    /// Spacing with the default value of `16` at a normal dynamic type setting.
    public static var s4: Self { .init(.s4) }
    /// Spacing with the default value of `24` at a normal dynamic type setting.
    public static var s5: Self { .init(.s5) }
    /// Spacing with the default value of `32` at a normal dynamic type setting.
    public static var s6: Self { .init(.s6) }
}

// MARK: - UIColor

extension UIColor {
    /// Returns default system tint color.
    public static var systemTint: UIColor {
        struct Static {
            static let tintColor = UIView().tintColor ?? .systemBlue
        }

        return Static.tintColor
    }
}

// MARK: - URL

extension URL {
    public static var mailApp: Self { URL(string: "message://")! }
}

// MARK: - Character

extension Character {
    /// The character used for masking strings.
    public static var mask: Self = "•"
}

// MARK: - App Constants

public enum AppConstants {
    /// The golden ratio.
    public static var φ: CGFloat { 0.618 }

    public static var statusBarHeight: CGFloat {
        UIApplication
            .sharedOrNil?
            .firstSceneKeyWindow?
            .windowScene?
            .statusBarManager?
            .statusBarFrame.height ?? 44
    }

    public static var statusBarPlusNavBarHeight: CGFloat {
        statusBarHeight + navBarHeight
    }

    public static var navBarHeight: CGFloat {
        if UIDevice.current.modelType.family == .pad {
            return 50
        }

        return 44
    }

    public static var navBarItemHeight: CGFloat { 24 }
    public static var tabBarHeight: CGFloat { 49 }
    public static var uiControlsHeight: CGFloat { 50 }
    public static var searchBarHeight: CGFloat {
        uiControlsHeight
    }

    public static var hairline: CGFloat = 0.5
    public static var tileCornerRadius: CGFloat = 11
    public static var cornerRadius: CGFloat = 6
}

// MARK: - Device

extension AppConstants {
    public static var supportsHomeIndicator: Bool {
        UIDevice.current.capability.contains(.homeIndicator)
    }

    public static var homeIndicatorHeightIfPresent: CGFloat {
        supportsHomeIndicator ? 34 : 0
    }

    public static var smallScreenSize: Bool {
        let model = UIDevice.current.modelType
        guard model.family == .phone else {
            return false
        }
        return model.screenSize <= .iPhone5
    }

    public static var mediumScreenSize: Bool {
        UIDevice.current.modelType.screenSize.size.max <= iPhone6ScreenSize.max
    }

    public static var iPhone6ScreenSize: CGSize {
        UIDevice.Model.ScreenSize.iPhone6.size
    }

    /// A convenience function to get relative value for given device based on iPhone 6 width.
    public static func aspect(_ value: CGFloat, axis: NSLayoutConstraint.Axis = .vertical) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let reference = iPhone6ScreenSize
        let relation = axis == .vertical ? screenSize.height / reference.height : screenSize.width / reference.width
        return value * relation
    }

    public static func remaining(axis: NSLayoutConstraint.Axis = .vertical) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let reference = iPhone6ScreenSize
        let remaining = axis == .vertical ? screenSize.height - reference.height : screenSize.width - reference.width
        return max(0.0, remaining)
    }
}
