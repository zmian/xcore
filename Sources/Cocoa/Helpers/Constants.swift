//
// Constants.swift
//
// Copyright © 2017 Xcore
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
    public static var fast: TimeInterval = 0.25

    /// The normal duration to use for animations when the desired interval is
    /// between `0.3...0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .normal) {
    ///     ...
    /// }
    /// ```
    public static var normal: TimeInterval = 0.35

    /// The slow duration to use for animations when the desired interval is between
    /// `> 0.5` seconds.
    ///
    /// ```swift
    /// UIView.animate(withDuration: .slow) {
    ///     ...
    /// }
    /// ```
    public static var slow: TimeInterval = 0.5
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
    public static var defaultScale: CGAffineTransform {
        return CGAffineTransform(scaleX: 0.95, y: 0.95)
    }
}

// MARK: - CGFloat

extension CGFloat {
    public static let minimumPadding: CGFloat = 8
    public static let defaultPadding: CGFloat = 15
    public static let maximumPadding: CGFloat = 30

    /// A convenience method to return `1` pixel relative to the screen scale.
    public static var onePixel: CGFloat {
        struct Static {
            static let onePixel = UIView().onePixel
        }

        return Static.onePixel
    }
}

// MARK: - UIEdgeInsets

extension UIEdgeInsets {
    public static let minimumPadding = UIEdgeInsets(.minimumPadding)
    public static let defaultPadding = UIEdgeInsets(.defaultPadding)
    public static let maximumPadding = UIEdgeInsets(.maximumPadding)
}

// MARK: - UIColor

extension UIColor {
    /// Returns default system tint color.
    public static var systemTint: UIColor {
        struct Static {
            static let tintColor = UIView().tintColor ?? .appleBlue
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
    @nonobjc static var appleGray: UIColor { return UIColor(hex: "EBF2FB") }
    @nonobjc static var appleTealBlue: UIColor { return UIColor(hex: "5AC8FA") }
    @nonobjc static var appleBlue: UIColor { return UIColor(hex: "007AFF") }
    @nonobjc static var applePurple: UIColor { return UIColor(hex: "5856D6") }
    @nonobjc static var appleGreen: UIColor { return UIColor(hex: "4CD964") }
    @nonobjc static var appleRed: UIColor { return UIColor(hex: "FF3B30") }
}

// MARK: - App Constants

public struct AppConstants {
    /// The golden ratio.
    public static var φ: CGFloat { return 0.618 }

    public static var statusBarHeight: CGFloat {
        return UIApplication.sharedOrNil?.statusBarFrame.height ?? 20
    }

    public static var statusBarPlusNavBarHeight: CGFloat {
        return statusBarHeight + navBarHeight
    }

    public static var navBarHeight: CGFloat {
        if UIDevice.current.modelType.family == .pad, #available(iOS 12.0, *) {
            return 50
        }

        return 44
    }

    public static var navBarItemHeight: CGFloat { return 24 }
    public static var tabBarHeight: CGFloat { return 49 }
    public static var uiControlsHeight: CGFloat { return 50 }
    public static var searchBarHeight: CGFloat {
        return uiControlsHeight
    }

    public static var hairline: CGFloat = 0.5
    public static var tileCornerRadius: CGFloat = 11
    public static var cornerRadius: CGFloat = 6
}

// MARK: - Device

extension AppConstants {
    public static var supportsHomeIndicator: Bool {
        return UIDevice.current.capability.contains(.homeIndicator)
    }

    public static var homeIndicatorHeightIfPresent: CGFloat {
        return supportsHomeIndicator ? 34 : 0
    }

    public static var smallScreenSize: Bool {
        return UIDevice.current.modelType.screenSize <= .iPhone5
    }

    public static var mediumScreenSize: Bool {
        return UIDevice.current.modelType.screenSize.size.max <= iPhone6ScreenSize.max
    }

    public static var iPhone6ScreenSize: CGSize {
        return UIDevice.ModelType.ScreenSize.iPhone6.size
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

// MARK: - Global

/// Returns the name of a `type` as a string.
///
/// - Parameter value: The value for which to get the dynamic type name.
/// - Returns: A string containing the name of `value`'s dynamic type.
public func name(of value: Any) -> String {
    let kind = value is Any.Type ? value : Swift.type(of: value)
    let description = String(reflecting: kind)

    // Swift compiler bug causing unexpected result when getting a String describing
    // a type created inside a function.
    //
    // https://bugs.swift.org/browse/SR-6787

    let unwantedResult = "(unknown context at "
    guard description.contains(unwantedResult) else {
        return description
    }

    let components = description.split(separator: ".").filter { !$0.hasPrefix(unwantedResult) }
    return components.joined(separator: ".")
}
