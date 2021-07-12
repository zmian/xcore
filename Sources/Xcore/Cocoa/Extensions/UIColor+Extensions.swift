//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Hex Support

extension UIColor {
    public convenience init(hex: Int64) {
        let (r, g, b, a) = Self.components(hex: hex)
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    public convenience init(hex: Int64, alpha: CGFloat) {
        let (r, g, b, a) = Self.components(hex: hex, alpha: alpha)
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    @nonobjc
    public convenience init(hex: String) {
        self.init(hex: Self.components(hex: hex))
    }

    @nonobjc
    public convenience init(hex: String, alpha: CGFloat) {
        self.init(hex: Self.components(hex: hex), alpha: alpha)
    }

    public var hex: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "#000000"
        }

        func round(_ value: CGFloat) -> Int {
            lround(Double(value) * 255)
        }

        if alpha == 1 {
            return String(format: "#%02lX%02lX%02lX", round(red), round(green), round(blue))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX", round(red), round(green), round(blue), round(alpha))
        }
    }

    private static func components(hex: Int64, alpha: CGFloat? = nil) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let preferredAlpha = alpha

        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat

        let isRGBA = CGFloat(hex & 0xff000000) != 0

        if isRGBA {
            r = CGFloat((hex & 0xff000000) >> 24) / 255
            g = CGFloat((hex & 0xff0000) >> 16) / 255
            b = CGFloat((hex & 0xff00) >> 8) / 255
            a = preferredAlpha ?? CGFloat(hex & 0xff) / 255
        } else {
            r = CGFloat((hex & 0xff0000) >> 16) / 255
            g = CGFloat((hex & 0xff00) >> 8) / 255
            b = CGFloat(hex & 0xff) / 255
            a = preferredAlpha ?? 1
        }

        return (r, g, b, a)
    }

    private static func components(hex: String) -> Int64 {
        var hexString = hex

        if hexString.hasPrefix("#"), let cleanString = hexString.stripPrefix("#") {
            hexString = cleanString
        }

        return Int64(hexString, radix: 16) ?? 0x000000
    }

    private func components(normalize: Bool = true) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        if normalize {
            r *= 255
            g *= 255
            b *= 255
        }

        return (r, g, b, a)
    }
}

// MARK: - Alpha

extension UIColor {
    public var alpha: CGFloat {
        get { cgColor.alpha }
        set { withAlphaComponent(newValue) }
    }

    public func alpha(_ value: CGFloat) -> UIColor {
        withAlphaComponent(value)
    }
}

// MARK: - Lighter & Darker

extension UIColor {
    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(_ amount: CGFloat = 0.25) -> UIColor {
        hueColorWithBrightness(1 + amount)
    }

    public func darker(_ amount: CGFloat = 0.25) -> UIColor {
        hueColorWithBrightness(1 - amount)
    }

    private func hueColorWithBrightness(_ amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        } else {
            return self
        }
    }

    public func isLight(threshold: CGFloat = 0.6) -> Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > threshold
    }
}

// MARK: - Blend

extension UIColor {
    /// Blend multiply given color with `self`.
    public func multiply(_ color: UIColor, alpha: CGFloat = 1) -> UIColor {
        let bg = components(normalize: false)
        let fg = color.components(normalize: false)

        let r = bg.r * fg.r
        let g = bg.g * fg.g
        let b = bg.b * fg.b
        let a = alpha * fg.a + (1 - alpha) * bg.a

        return UIColor(
            red: r.clamped(to: 0...255),
            green: g.clamped(to: 0...255),
            blue: b.clamped(to: 0...255),
            alpha: a
        )
    }
}

// MARK: - Random

extension UIColor {
    public static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

// MARK: - Cross Fade

extension UIColor {
    /// A convenience function to cross fade to the given color by the specified
    /// delta.
    ///
    /// - Parameters:
    ///   - color: The color to which self should cross fade.
    ///   - percentage: The delta of the cross fade.
    /// - Returns: An instance of cross faded `UIColor`.
    open func crossFade(to color: UIColor, delta percentage: CGFloat) -> UIColor {
        let fromColor = self
        let toColor = color

        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0

        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0

        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * percentage + fromRed
        let green = (toGreen - fromGreen) * percentage + fromGreen
        let blue = (toBlue - fromBlue) * percentage + fromBlue
        let alpha = (toAlpha - fromAlpha) * percentage + fromAlpha

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - Color Scheme Mode

extension UIColor {
    /// Creates a color object that generates its color data dynamically using the
    /// specified colors.
    ///
    /// - Parameters:
    ///   - light: The color for light mode.
    ///   - dark: The color for dark mode.
    public convenience init(
        light: @autoclosure @escaping () -> UIColor,
        dark: @autoclosure @escaping () -> UIColor
    ) {
        self.init {
            switch $0.userInterfaceStyle {
                case .dark:
                    return dark()
                default:
                    return light()
            }
        }
    }

    /// Returns the version of the current color that takes the specified user
    /// interface style into account.
    ///
    /// - Parameter userInterfaceStyle: The style to use when resolving the color
    ///   information.
    /// - Returns: The version of the color to display for the specified style.
    public func resolve(for userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        resolvedColor(with: .init(userInterfaceStyle: userInterfaceStyle))
    }
}

extension Array where Element: UIColor {
    /// The Quartz color reference that corresponds to the receiver’s color.
    public var cgColor: [CGColor] {
        map(\.cgColor)
    }
}
