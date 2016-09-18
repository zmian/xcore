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
    fileprivate var observeBackgroundColorSetter = true
    fileprivate var regularBackgroundColor: UIColor?

    @nonobjc open var highlightedBackgroundColor: UIColor?
    @nonobjc open var disabledBackgroundColor: UIColor?

    open override var backgroundColor: UIColor? {
        didSet {
            if observeBackgroundColorSetter {
                regularBackgroundColor = backgroundColor
            }
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            changeBackgroundColor(to: highlightedBackgroundColor, forState: isHighlighted)
        }
    }

    open override var isEnabled: Bool {
        didSet {
            changeBackgroundColor(to: disabledBackgroundColor, forState: !isEnabled)
        }
    }

    open override func setHighlightedBackgroundColor(_ color: UIColor?) {
        highlightedBackgroundColor = color
    }

    open override func setDisabledBackgroundColor(_ color: UIColor?) {
        disabledBackgroundColor = color
    }

    fileprivate func changeBackgroundColor(to color: UIColor?, forState: Bool) {
        observeBackgroundColorSetter = false

        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundColor = forState ? color : self.regularBackgroundColor
        }, completion: { _ in
            self.observeBackgroundColorSetter = true
        })
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
