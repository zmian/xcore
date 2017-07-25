//
// Colorable.swift
//
// Copyright © 2017 Zeeshan Mian
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

public protocol Colorable {
    var color: UIColor { get }
}

extension UIScrollView {
    /// A convenience function to cross fade between two color in given items.
    open func crossFadeColor(previousPageIndex: Int, items: [Colorable]) -> UIColor {
        let delta = (contentOffset.x - CGFloat(previousPageIndex) * frame.width) / frame.width
        let fromColor = items.at(previousPageIndex)?.color ?? .black
        let toColor = items.at(delta > 0 ? previousPageIndex + 1 : previousPageIndex - 1)?.color ?? fromColor
        return .crossFade(from: fromColor, to: toColor, delta: abs(delta))
    }
}

extension UIColor {
    /// A convenience function to cross fade between two color at given delta.
    open static func crossFade(from color: UIColor, to theColor: UIColor, delta percentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0

        color.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0

        theColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * percentage + fromRed;
        let green = (toGreen - fromGreen) * percentage + fromGreen;
        let blue = (toBlue - fromBlue) * percentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * percentage + fromAlpha;

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
