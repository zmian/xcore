//
// UIBarButtonItem+Extensions.swift
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

// MARK: TextColor

extension UIBarButtonItem {
    @objc open dynamic var textColor: UIColor? {
        get { return titleTextColor(for: .normal) }
        set { setTitleTextColor(newValue, for: .normal) }
    }

    open func titleTextColor(for state: UIControl.State) -> UIColor? {
        return titleTextAttribute(.foregroundColor, for: state)
    }

    open func setTitleTextColor(_ color: UIColor?, for state: UIControl.State) {
        setTitleTextAttribute(.foregroundColor, value: color, for: state)
    }
}

// MARK: Font

extension UIBarButtonItem {
    @objc open dynamic var font: UIFont? {
        get { return titleTextFont(for: .normal) }
        set {
            UIControl.State.applicationStates.forEach {
                setTitleTextFont(newValue, for: $0)
            }
        }
    }

    open func titleTextFont(for state: UIControl.State) -> UIFont? {
        return titleTextAttribute(.font, for: state)
    }

    open func setTitleTextFont(_ font: UIFont?, for state: UIControl.State) {
        setTitleTextAttribute(.font, value: font, for: state)
    }
}

// MARK: Helpers

extension UIBarButtonItem {
    private func titleTextAttribute<T>(_ key: NSAttributedString.Key, for state: UIControl.State) -> T? {
        return titleTextAttributes(for: state)?[key] as? T
    }

    private func setTitleTextAttribute(_ key: NSAttributedString.Key, value: Any?, for state: UIControl.State) {
        var attributes = titleTextAttributes(for: state) ?? [:]
        attributes[key] = value
        setTitleTextAttributes(attributes, for: state)
    }
}

extension UIControl.State {
    fileprivate static var applicationStates: [UIControl.State] {
        return [.normal, .highlighted, .disabled, .selected, .focused, .application]
    }
}
