//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit
import SwiftUI

extension UIColor {
    public convenience init(
        _ colorSpace: Color.RGBColorSpace,
        red: CGFloat,
        green: CGFloat,
        blue: CGFloat,
        alpha: CGFloat
    ) {
        switch colorSpace {
            case .displayP3:
                self.init(displayP3Red: red, green: green, blue: blue, alpha: alpha)
            default:
                self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    }
}

// MARK: - Hex Support

extension UIColor {
    public convenience init(_ colorSpace: Color.RGBColorSpace = .default, hex: Int64, alpha: CGFloat? = nil) {
        let (r, g, b, a) = Self.components(hex: hex, alpha: alpha)
        self.init(colorSpace, red: r, green: g, blue: b, alpha: a)
    }

    public convenience init(_ colorSpace: Color.RGBColorSpace = .default, hex: String, alpha: CGFloat? = nil) {
        let components = Int64(hex.droppingPrefix("#"), radix: 16) ?? 0x000000
        self.init(colorSpace, hex: components, alpha: alpha)
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
}

// MARK: - Alpha

extension UIColor {
    /// The value of the alpha component associated with a color.
    public var alpha: CGFloat {
        get { cgColor.alpha }
        set { withAlphaComponent(newValue) }
    }

    public func alpha(_ alpha: CGFloat) -> UIColor {
        // The colors are lazily evaluated. Please don't assign to variable as it won't
        // be dark mode compliant.
        let copy = copy() as! UIColor
        return UIColor(light: copy.withAlphaComponent(alpha), dark: copy.withAlphaComponent(alpha))
    }
}

// MARK: - Lighter & Darker

extension UIColor {
    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(_ amount: CGFloat = 0.25) -> UIColor {
        hsbColor(brightness: 1 + amount)
    }

    public func darker(_ amount: CGFloat = 0.25) -> UIColor {
        hsbColor(brightness: 1 - amount)
    }

    private func hsbColor(brightness amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return self
        }

        return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
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
            .default,
            red: r.clamped(to: 0...255),
            green: g.clamped(to: 0...255),
            blue: b.clamped(to: 0...255),
            alpha: a
        )
    }

    private func components(normalize: Bool) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
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

// MARK: - Random

extension UIColor {
    /// Returns a random color.
    @_disfavoredOverload
    public static func random() -> UIColor {
        let hue = CGFloat(Int.random() % 256) / 256
        let saturation = CGFloat(Int.random() % 128) / 256 + 0.5
        let brightness = CGFloat(Int.random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

// MARK: - Color Scheme

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
                case .dark: dark()
                default: light()
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

// MARK: - CGColor

extension Array<UIColor> {
    /// The Quartz color reference that corresponds to the receiver’s color.
    public var cgColor: [CGColor] {
        map(\.cgColor)
    }
}

extension CGColor {
    /// The `UIColor` that corresponds to the color object.
    public var uiColor: UIColor {
        UIColor(cgColor: self)
    }
}
#endif
