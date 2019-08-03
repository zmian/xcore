//
// UIColor+Extensions.swift
//
// Copyright © 2014 Xcore
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

import UIKit

// MARK: - Hex Support

extension UIColor {
    public convenience init(hex: Int64) {
        let (r, g, b, a) = UIColor.components(hex: hex)
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    public convenience init(hex: Int64, alpha: CGFloat) {
        let (r, g, b, a) = UIColor.components(hex: hex, alpha: alpha)
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    @nonobjc
    public convenience init(hex: String) {
        self.init(hex: UIColor.components(hex: hex))
    }

    @nonobjc
    public convenience init(hex: String, alpha: CGFloat) {
        self.init(hex: UIColor.components(hex: hex), alpha: alpha)
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
            return lround(Double(value) * 255)
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

        let isRGBA = CGFloat(hex & 0xFF000000) != 0

        if isRGBA {
            r = CGFloat((hex & 0xFF000000) >> 24) / 255
            g = CGFloat((hex & 0xFF0000)   >> 16) / 255
            b = CGFloat((hex & 0xFF00)     >>  8) / 255
            a = preferredAlpha ?? CGFloat((hex & 0xFF)) / 255
        } else {
            r = CGFloat((hex & 0xFF0000)   >> 16) / 255
            g = CGFloat((hex & 0xFF00)     >>  8) / 255
            b = CGFloat((hex & 0xFF)            ) / 255
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
}

extension UIColor {
    public var alpha: CGFloat {
        get { return cgColor.alpha }
        set { withAlphaComponent(newValue) }
    }

    public func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }

    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(_ amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightness(1 + amount)
    }

    public func darker(_ amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightness(1 - amount)
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

    public static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    func isLight(threshold: CGFloat = 0.6) -> Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > threshold
    }
}

extension Array where Element: UIColor {
    /// The Quartz color reference that corresponds to the receiver’s color.
    public var cgColor: [CGColor] {
        return map { $0.cgColor }
    }
}
