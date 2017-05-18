//
// UIColorExtensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

extension UIColor {
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    @nonobjc
    public convenience init(hex: String, alpha: CGFloat = 1) {
        var hexString = hex
        if hexString.hasPrefix("#"), let cleanString = hexString.stripPrefix("#") {
            hexString = cleanString
        }

        if let hex = Int(hexString, radix: 16) {
            self.init(hex: hex, alpha: alpha)
        } else {
            self.init(hex: 0x000000, alpha: alpha)
        }
    }

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

    fileprivate func hueColorWithBrightness(_ amount: CGFloat) -> UIColor {
        var hue: CGFloat        = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat      = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        } else {
            return self
        }
    }

    /// A convenience method to return default system tint color.
    ///
    /// - returns: The default tint color.
    public static func defaultSystemTintColor() -> UIColor {
        struct Static {
            static let tintColor = UIView().tintColor
        }

        return Static.tintColor!
    }

    public static func randomColor() -> UIColor {
        let hue        = CGFloat(arc4random() % 256) / 256
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
