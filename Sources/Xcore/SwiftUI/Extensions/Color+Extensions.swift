//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Color.RGBColorSpace {
    nonisolated(unsafe) public static var `default`: Self = .sRGB
}

// MARK: - Hex Support

extension Color {
    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: Int64, opacity: CGFloat? = nil) {
        self.init(uiColor: UIColor(colorSpace, hex: hex, alpha: opacity))
    }

    public init(_ colorSpace: Color.RGBColorSpace = .default, hex: String, opacity: CGFloat? = nil) {
        self.init(uiColor: UIColor(colorSpace, hex: hex, alpha: opacity))
    }
}

// MARK: - Random

extension Color {
    /// Returns a random color.
    public static func random() -> Self {
        let hue = CGFloat(Int.random() % 256) / 256
        let saturation = CGFloat(Int.random() % 128) / 256 + 0.5
        let brightness = CGFloat(Int.random() % 128) / 256 + 0.5
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
}

// MARK: - Lighter & Darker

extension Color {
    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(_ amount: CGFloat = 0.25) -> Color {
        hsbColor(brightness: 1 + amount)
    }

    public func darker(_ amount: CGFloat = 0.25) -> Color {
        hsbColor(brightness: 1 - amount)
    }

    private func hsbColor(brightness amount: CGFloat) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }

        return Color(hue: hue, saturation: saturation, brightness: brightness * amount, opacity: alpha)
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

// MARK: - Color Scheme

extension Color {
    /// Creates a color that adapts to the current context using the specified
    /// colors.
    ///
    /// - Parameters:
    ///   - light: The color for light color scheme.
    ///   - dark: The color for dark color scheme.
    public init(light: Color, dark: Color) {
        let shapeStyle = ColorSchemeShapeStyle(light: light, dark: dark)
        self.init(shapeStyle)
    }

    private struct ColorSchemeShapeStyle: ShapeStyle, Hashable {
        let light: Color
        let dark: Color

        func resolve(in environment: EnvironmentValues) -> Color.Resolved {
            switch environment.colorScheme {
                case .dark: dark.resolve(in: environment)
                case .light: light.resolve(in: environment)
                @unknown default: light.resolve(in: environment)
            }
        }
    }
}

// MARK: - Resolve

extension Color {
    /// Returns a new Color resolved for the specified color scheme.
    ///
    /// This method creates an `EnvironmentValues` instance with the given
    /// color scheme, then resolves the current color within that environment.
    /// It is useful for dynamically adjusting the color to a particular color
    /// scheme.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let someColor = Color(.someColor)
    /// let resolvedColor = someColor.resolve(for: .light)
    /// ```
    ///
    /// - Parameter colorScheme: The color scheme for which the color should be
    ///   resolved.
    /// - Returns: A new `Color` instance resolved for the specified color scheme.
    public func resolve(for colorScheme: ColorScheme) -> Self {
        var env = EnvironmentValues()
        env.colorScheme = colorScheme
        return Color(resolve(in: env))
    }
}

// MARK: - UIColor

extension Color {
    /// The `UIColor` that corresponds to the color object.
    public var uiColor: UIColor {
        UIColor(self)
    }
}
