//
// UIBarButtonItem+Extensions.swift
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

extension UIBarButtonItem {
    @objc open dynamic var textColor: UIColor? {
        get { return titleTextAttributes(for: .normal)?[NSAttributedStringKey.foregroundColor.rawValue] as? UIColor }
        set {
            var attributes = _titleTextAttributes(for: .normal)
            attributes[.foregroundColor] = newValue
            setTitleTextAttributes(attributes, for: .normal)
        }
    }

    @objc open dynamic var font: UIFont? {
        get { return titleTextFont(for: .normal) }
        set {
            UIControlState.applicationStates.forEach {
                setTitleTextFont(newValue, for: $0)
            }
        }
    }

    open func titleTextFont(for state: UIControlState) -> UIFont? {
        return titleTextAttributes(for: state)?[NSAttributedStringKey.font.rawValue] as? UIFont
    }

    open func setTitleTextFont(_ font: UIFont?, for state: UIControlState) {
        var attributes = _titleTextAttributes(for: .normal)
        attributes[.font] = font
        setTitleTextAttributes(attributes, for: .normal)
    }

    private func _titleTextAttributes(for state: UIControlState) -> [NSAttributedStringKey: Any] {
        guard let oldAttributes = titleTextAttributes(for: state) else {
            return [:]
        }

        var newAttributes = [NSAttributedStringKey: Any]()

        for (key, value) in oldAttributes {
            newAttributes[NSAttributedStringKey(rawValue: key)] = value
        }

        return newAttributes
    }
}

extension UIControlState {
    fileprivate static var applicationStates: [UIControlState] {
        return [.normal, .highlighted, .disabled, .selected, .focused, .application]
    }
}
