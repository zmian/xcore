//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Color.RGBColorSpace {
    public static var `default`: Self = .sRGB
}

// MARK: - Hex Support

extension Color {
    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: Int64) {
        self.init(UIColor(colorSpace, hex: hex))
    }

    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: Int64, opacity: CGFloat) {
        self.init(UIColor(colorSpace, hex: hex, alpha: opacity))
    }

    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: String) {
        self.init(UIColor(colorSpace, hex: hex))
    }

    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: String, opacity: CGFloat) {
        self.init(UIColor(colorSpace, hex: hex, alpha: opacity))
    }
}

// MARK: - Random

extension Color {
    /// Returns a random color.
    public static func random() -> Self {
        let hue = CGFloat(Int.random() % 256) / 256
        let saturation = CGFloat(Int.random() % 128) / 256 + 0.5
        let brightness = CGFloat(Int.random() % 128) / 256 + 0.5
        return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: 1)
    }
}

// MARK: - Lighter & Darker

extension Color {
    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(_ amount: CGFloat = 0.25) -> Color {
        hueColorWithBrightness(1 + amount)
    }

    public func darker(_ amount: CGFloat = 0.25) -> Color {
        hueColorWithBrightness(1 - amount)
    }

    private func hueColorWithBrightness(_ amount: CGFloat) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return Color(hue: hue, saturation: saturation, brightness: brightness * amount, opacity: alpha)
        } else {
            return self
        }
    }
}

// MARK: - Similarity

extension Color {
    /// Returns Boolean value indicating whether the given color and `self` feels
    /// similar to the human eyes.
    ///
    /// - Parameters:
    ///   - color: The color to compare to.
    ///   - threshold: The threshold to decide similarity. The smaller the threshold
    ///     the stricter the algorithm.
    /// - Returns: A Boolean indicating whether the colors are similar.
    public func isSimilar(to color: Color, threshold: CGFloat = 0.1) -> Bool {
        let color = color.uiColor
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        var otherRed: CGFloat = 0
        var otherGreen: CGFloat = 0
        var otherBlue: CGFloat = 0
        var otherAlpha: CGFloat = 0
        color.getRed(&otherRed, green: &otherGreen, blue: &otherBlue, alpha: &otherAlpha)

        func isSimilar(lhs: CGFloat, rhs: CGFloat) -> Bool {
            abs(lhs - rhs) <= (lhs * threshold)
        }

        return
            isSimilar(lhs: red, rhs: otherRed) &&
            isSimilar(lhs: green, rhs: otherGreen) &&
            isSimilar(lhs: blue, rhs: otherBlue) &&
            isSimilar(lhs: alpha, rhs: otherAlpha)
    }
}

// MARK: - Cross Fade

extension Color {
    /// Returns a transition color from `self` to the given color based on the given
    /// delta.
    ///
    /// - Parameters:
    ///   - color: The color to which self should cross fade.
    ///   - percentage: The delta of the cross fade.
    /// - Returns: An instance of cross faded `UIColor`.
    public func crossFade(to color: Color, delta percentage: CGFloat) -> Color {
        let fromColor = uiColor
        let toColor = color.uiColor

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

        return Color(.default, red: red, green: green, blue: blue, opacity: alpha)
    }
}

// MARK: - Color Scheme Mode

extension Color {
    /// Creates a color object that generates its color data dynamically using the
    /// specified colors.
    ///
    /// - Parameters:
    ///   - light: The color for light color scheme.
    ///   - dark: The color for dark color scheme.
    public init(
        light: @autoclosure @escaping () -> Color,
        dark: @autoclosure @escaping () -> Color
    ) {
        self.init(UIColor {
            switch $0.userInterfaceStyle {
                case .dark:
                    return UIColor(dark())
                default:
                    return UIColor(light())
            }
        })
    }

    /// Creates a color object that generates its color data dynamically using the
    /// specified colors.
    ///
    /// - Parameters:
    ///   - light: The color for light color scheme.
    ///   - dark: The color for dark color scheme.
    @_disfavoredOverload
    public init(
        light: @autoclosure @escaping () -> UIColor,
        dark: @autoclosure @escaping () -> UIColor
    ) {
        self.init(UIColor {
            switch $0.userInterfaceStyle {
                case .dark:
                    return dark()
                default:
                    return light()
            }
        })
    }
}

extension Color {
    /// The `UIColor` that corresponds to the color object.
    public var uiColor: UIColor {
        UIColor(self)
    }
}
