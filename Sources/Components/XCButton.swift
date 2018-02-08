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
    fileprivate typealias State = UInt
    fileprivate var backgroundColors = [State: UIColor?]()
    fileprivate var borderColors = [State: UIColor?]()

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

    open func setEnabled(_ enable: Bool, animated: Bool) {
        if animated {
            self.isEnabled = enable
        } else {
            UIView.performWithoutAnimation { [weak self] in
                self?.isEnabled = enable
            }
        }
    }

    open override var backgroundColor: UIColor? {
        get { return backgroundColor(for: .normal) }
        set { setBackgroundColor(newValue, for: .normal) }
    }

    @nonobjc open var highlightedBackgroundColor: UIColor? {
        get { return backgroundColor(for: .highlighted) }
        set { setBackgroundColor(newValue, for: .highlighted) }
    }

    @nonobjc open var disabledBackgroundColor: UIColor? {
        get { return backgroundColor(for: .disabled) }
        set { setBackgroundColor(newValue, for: .disabled) }
    }
}

// MARK: Background Color

extension XCButton {
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

    open override func setHighlightedBackgroundColor(_ color: UIColor?) {
        highlightedBackgroundColor = color
    }

    open override func setDisabledBackgroundColor(_ color: UIColor?) {
        disabledBackgroundColor = color
    }

    fileprivate func changeBackgroundColor(to state: UIControlState) {
        var newBackgroundColor = backgroundColor(for: state)

        if newBackgroundColor == nil {
            if state == .highlighted {
                newBackgroundColor = backgroundColor(for: .normal)?.darker(0.1)
            } else if state == .disabled {
                newBackgroundColor = backgroundColor(for: .normal)?.lighter(0.1)
            }
        }

        guard let finalBackgroundColor = newBackgroundColor, super.backgroundColor != finalBackgroundColor else {
            return
        }

        UIView.animateFromCurrentState {
            super.backgroundColor = finalBackgroundColor
        }
    }
}

// MARK: Border Color

extension XCButton {
    open func setBorderColor(_ borderColor: UIColor?, for state: UIControlState) {
        borderColors[state.rawValue] = borderColor

        if state == .normal {
            super.layer.borderColor = borderColor?.cgColor
        }
    }

    open func borderColor(for state: UIControlState) -> UIColor? {
        guard let color = borderColors[state.rawValue] else {
            return nil
        }

        return color
    }

    fileprivate func changeBorderColor(to state: UIControlState) {
        var newBorderColor = borderColor(for: state)

        if newBorderColor == nil {
            if state == .highlighted {
                newBorderColor = borderColor(for: state)?.darker(0.1)
            } else if state == .disabled {
                newBorderColor = borderColor(for: state)?.lighter(0.1)
            }
        }

        guard let finalBorderColor = newBorderColor, super.layer.borderColor != finalBorderColor.cgColor else {
            return
        }

        UIView.animateFromCurrentState {
            super.layer.borderColor = finalBorderColor.cgColor
        }
    }
}

extension UIView {
    fileprivate static func animateFromCurrentState(_ animations: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .beginFromCurrentState, animations: {
            animations()
        }, completion: nil)
    }
}
