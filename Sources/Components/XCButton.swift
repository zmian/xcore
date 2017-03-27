//
// XCButton.swift
//
// Copyright © 2016 Zeeshan Mian
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

@IBDesignable
open class XCButton: UIButton {
    private typealias State = UInt
    private var backgroundColors = [State: UIColor?]()

    open func setBackgroundColor(_ backgroundColor: UIColor?, for state: UIControlState) {
        backgroundColors[state.rawValue] = backgroundColor

        if state == .normal {
            super.backgroundColor = backgroundColor
        }
    }

    open func backgroundColor(for state: UIControlState) -> UIColor? {
        guard let color = backgroundColors[state.rawValue] else {
            return nil
        }

        return color
    }

    @nonobjc open var highlightedBackgroundColor: UIColor? {
        get { return backgroundColor(for: .highlighted) }
        set { setBackgroundColor(newValue, for: .highlighted) }
    }

    @nonobjc open var disabledBackgroundColor: UIColor? {
        get { return backgroundColor(for: .disabled) }
        set { setBackgroundColor(newValue, for: .disabled) }
    }

    open override var backgroundColor: UIColor? {
        get { return backgroundColor(for: .normal) }
        set { setBackgroundColor(newValue, for: .normal) }
    }

    open override var isHighlighted: Bool {
        didSet {
            changeBackgroundColor(to: isHighlighted ? .highlighted : .normal)
        }
    }

    open override var isEnabled: Bool {
        didSet {
            changeBackgroundColor(to: isEnabled ? .normal : .disabled)
        }
    }

    open override func setHighlightedBackgroundColor(_ color: UIColor?) {
        highlightedBackgroundColor = color
    }

    open override func setDisabledBackgroundColor(_ color: UIColor?) {
        disabledBackgroundColor = color
    }

    fileprivate func changeBackgroundColor(to state: UIControlState) {
        let normalBackgroundColor = backgroundColor

        UIView.animate(withDuration: 0.25) {
            super.backgroundColor = self.backgroundColor(for: state)
        }
    }

    open func setEnabled(enabled: Bool, animated: Bool) {
        if animated {
            self.isEnabled = enabled
        } else {
            UIView.performWithoutAnimation {[weak self] in
                self?.isEnabled = enabled
            }
        }
    }
}
