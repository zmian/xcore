//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

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
    public static let fast: Self = 0.25

    /// The default duration to use for animations when the desired interval is
    /// between `0.3...0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .default) {
    ///     ...
    /// }
    /// ```
    public static let `default`: Self = 0.35

    /// The slow duration to use for animations when the desired interval is between
    /// `> 0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .slow) {
    ///     ...
    /// }
    /// ```
    public static let slow: Self = 0.5
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
    public static let s1: Self = 4
    /// Spacing with the default value of `8` at a normal dynamic type setting.
    public static let s2: Self = 8
    /// Spacing with the default value of `12` at a normal dynamic type setting.
    ///
    /// Matches the launch default for ``Theme/interItemHSpacing`` (`Theme.init` uses `.s3`).
    /// See `docs/architecture/SPACING_SCALE.md` (enforced by `audit_spacing_scale.sh`).
    public static let s3: Self = 12
    /// Spacing with the default value of `16` at a normal dynamic type setting.
    public static let s4: Self = 16
    /// Spacing with the default value of `20` at a normal dynamic type setting.
    ///
    /// Matches the launch default for ``Theme/defaultSpacing`` (`Theme.init` uses `.s5`).
    /// See `docs/architecture/SPACING_SCALE.md` (enforced by `audit_spacing_scale.sh`).
    public static let s5: Self = 20
    /// Spacing with the default value of `24` at a normal dynamic type setting.
    public static let s6: Self = 24
    /// Spacing with the default value of `28` at a normal dynamic type setting.
    public static let s7: Self = 28
    /// Spacing with the default value of `32` at a normal dynamic type setting.
    public static let s8: Self = 32

    /// Forwards to ``Theme/default``; prefer ``EnvironmentValues/theme`` in SwiftUI.
    public static var defaultSpacing: Self {
        get { Theme.defaultSpacing }
        set { Theme.defaultSpacing = newValue }
    }

    /// Forwards to ``Theme/default``.
    public static var interItemHSpacing: Self {
        get { Theme.interItemHSpacing }
        set { Theme.interItemHSpacing = newValue }
    }

    /// Return true `1` pixel relative to the screen scale.
    public static var onePixel: Self {
        1 / Screen.main.scale
    }
}

// MARK: - EdgeInsets

extension EdgeInsets {
    /// The default insets for list content; forwards to ``Theme/listRowInsets``.
    public static var listRow: Self {
        Theme.listRowInsets
    }
}

// MARK: - URL

extension URL {
    /// The URL to deep link to **Apple Mail** app.
    public static var mailApp: Self {
        URL(string: "message://")!
    }

    /// The URL to deep link to your app’s custom settings in the Settings app.
    public static var settingsApp: Self {
        URL(string: UIApplication.openSettingsURLString)!
    }

    /// The URL to deep link to your app’s notification settings in the Settings
    /// app.
    public static var notificationSettings: Self {
        URL(string: UIApplication.openNotificationSettingsURLString)!
    }
}

// MARK: - Character

extension Character {
    /// The character used for masking strings.
    public static let mask: Self = "•"
}

// MARK: - String

extension String {
    /// Returns the minus sign [U+2212 − MINUS SIGN][Wikipedia].
    ///
    /// See [The Minus Sign, Don’t use a hyphen when you need a minus sign.][Oleb]
    ///
    /// [Oleb]: https://oleb.net/blog/2015/02/minus-sign
    /// [Wikipedia]: https://en.wikipedia.org/wiki/Plus_and_minus_signs
    public static let minusSign = "\u{2212}"
}

extension Int {
    @_disfavoredOverload
    public static let maxFractionDigits = 100

    @_disfavoredOverload
    public static let defaultFractionDigits = 2

    @_disfavoredOverload
    public static let defaultRandomUpperBound = 100
}

extension Double {
    public static let defaultRandomUpperBound = 100.0
}

extension RangeExpression where Self == ClosedRange<Int> {
    public static var defaultFractionDigits: Self {
        0...Int.defaultFractionDigits
    }

    public static var maxFractionDigits: Self {
        0...Int.maxFractionDigits
    }
}

// MARK: - App Constants

public enum AppConstants {
    /// The golden ratio.
    public static var φ: CGFloat { 0.618 }

    public static let statusBarHeight = MainActor.runImmediately {
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
        Device.userInterfaceIdiom == .pad ? 50 : 44
    }

    /// Forwards to ``Theme/default``; prefer ``EnvironmentValues/theme`` in SwiftUI.
    public static var cornerRadius: CGFloat {
        get { Theme.cornerRadius }
        set { Theme.cornerRadius = newValue }
    }

    public static var preferredMaxWidth: CGFloat {
        iPhoneXSScreenSize.width
    }

    static var popupPreferredWidth: CGFloat {
        min(300, Device.screen.bounds.size.min * 0.8)
    }
}

// MARK: - Device

extension AppConstants {
    public static var supportsHomeIndicator: Bool {
        Device.capability.contains(.homeIndicator)
    }

    public static var homeIndicatorHeightIfPresent: CGFloat {
        supportsHomeIndicator ? 34 : 0
    }

    public static var smallScreenSize: Bool {
        guard Device.userInterfaceIdiom == .phone else {
            return false
        }

        return Device.screen.referenceSize <= .iPhone5
    }

    public static var mediumScreenSize: Bool {
        Device.screen.referenceSize.size.max <= iPhoneXSScreenSize.max
    }

    public static var iPhoneXSScreenSize: CGSize {
        Screen.ReferenceSize.iPhoneXSMax.size
    }

    /// Returns relative value for the current device based on iPhone 6 width.
    @MainActor
    public static func aspect(_ value: CGFloat, axis: NSLayoutConstraint.Axis = .vertical) -> CGFloat {
        let screenSize = Screen.main.bounds.size
        let reference = iPhoneXSScreenSize
        let relation = axis == .vertical ? screenSize.height / reference.height : screenSize.width / reference.width
        return value * relation
    }

    @MainActor
    public static func remaining(axis: NSLayoutConstraint.Axis = .vertical) -> CGFloat {
        let screenSize = Screen.main.bounds.size
        let reference = iPhoneXSScreenSize
        let remaining = axis == .vertical ? screenSize.height - reference.height : screenSize.width - reference.width
        return max(0.0, remaining)
    }
}
