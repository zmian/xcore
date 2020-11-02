//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
    public static let minimumPadding: Self = 8
    public static let defaultPadding: Self = 15
    public static let maximumPadding: Self = 30

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
    public static let minimumPadding = Self(.minimumPadding)
    public static let defaultPadding = Self(.defaultPadding)
    public static let maximumPadding = Self(.maximumPadding)
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

    /// Returns default app tint color.
    @nonobjc public static var appTint: UIColor = .systemTint

    /// The color for app borders or divider lines that hide any underlying content.
    @nonobjc public static var appSeparator = UIColor(hex: "DFE9F5")
    @nonobjc public static var appHighlightedBackground = appSeparator
    @nonobjc public static var appBackgroundDisabled = appleGray
}

extension UIColor {
    @nonobjc static var appleGray: UIColor { .init(hex: "EBF2FB") }
    @nonobjc static var appleTealBlue: UIColor { .init(hex: "5AC8FA") }
    @nonobjc static var appleBlue: UIColor { .init(hex: "007AFF") }
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
