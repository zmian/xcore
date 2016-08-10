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
public class XCButton: UIButton {
    private var observeBackgroundColorSetter = true
    private var regularBackgroundColor: UIColor?

    @nonobjc public var highlightedBackgroundColor: UIColor?
    @nonobjc public var disabledBackgroundColor: UIColor?

    public override var backgroundColor: UIColor? {
        didSet {
            if observeBackgroundColorSetter {
                regularBackgroundColor = backgroundColor
            }
        }
    }

    public override var highlighted: Bool {
        didSet {
            changeBackgroundColor(to: highlightedBackgroundColor, forState: highlighted)
        }
    }

    public override var enabled: Bool {
        didSet {
            changeBackgroundColor(to: disabledBackgroundColor, forState: !enabled)
        }
    }

    public override func setHighlightedBackgroundColor(color: UIColor?) {
        highlightedBackgroundColor = color
    }

    public override func setDisabledBackgroundColor(color: UIColor?) {
        disabledBackgroundColor = color
    }

    private func changeBackgroundColor(to color: UIColor?, forState: Bool) {
        observeBackgroundColorSetter = false

        UIView.animateWithDuration(0.25, animations: {
            self.backgroundColor = forState ? color : self.regularBackgroundColor
        }, completion: { _ in
            self.observeBackgroundColorSetter = true
        })
    }

    public func setEnabled(enabled enabled: Bool, animated: Bool) {
        if animated {
            self.enabled = enabled
        } else {
            UIView.performWithoutAnimation {[weak self] in
                self?.enabled = enabled
            }
        }
    }
}
