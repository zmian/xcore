//
// BlurView.swift
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

public class BlurView: XCView {
    private var observer: NSObjectProtocol?
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var isReduceTransparencyEnabled: Bool {
        return UIAccessibilityIsReduceTransparencyEnabled()
    }

    /// A boolean property to determine whether this view automatically enables blur effect.
    /// When this property is `false` this classs acts as normal `UIView`.
    ///
    /// The default value is `true`.
    ///
    /// - Note:
    /// When this property is `true` it only enables blur effect when `UIAccessibilityIsReduceTransparencyEnabled()`
    /// is `false`. Otherwise, `blurEffectDisabledBackgroundColor` value is used instead of the blur effect.
    public var isSmartBlurEffectEnabled = true {
        didSet {
            guard oldValue != isSmartBlurEffectEnabled else { return }
            accessibilityReduceTransparencyStatusDidChange()
        }
    }

    /// The background color to use when `UIAccessibilityIsReduceTransparencyEnabled()` is `true`.
    /// The default value is `.white`.
    public var blurEffectDisabledBackgroundColor: UIColor = .white

    /// The `UIVisualEffect` to use when `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    /// The default value is `.light`.
    public var effect: UIVisualEffect? {
        get { return blurEffectView.effect }
        set { blurEffectView.effect = newValue }
    }

    public override func commonInit() {
        super.addSubview(blurEffectView)
        NSLayoutConstraint.constraintsForViewToFillSuperview(blurEffectView).activate()

        observer = NotificationCenter.default.addObserver(forName: .UIAccessibilityReduceTransparencyStatusDidChange, object: nil, queue: .main) { [weak self] _ in
            self?.accessibilityReduceTransparencyStatusDidChange()
        }

        accessibilityReduceTransparencyStatusDidChange()
    }

    deinit {
        guard let observer = observer else {
            return
        }

        NotificationCenter.default.removeObserver(observer)
    }

    private func accessibilityReduceTransparencyStatusDidChange() {
        guard isSmartBlurEffectEnabled else {
            blurEffectView.isHidden = true
            return
        }

        blurEffectView.isHidden = isReduceTransparencyEnabled
        backgroundColor = isReduceTransparencyEnabled ? blurEffectDisabledBackgroundColor : .clear
    }
}

extension BlurView {
    public override func addSubview(_ view: UIView) {
        if isSmartBlurEffectEnabled {
            blurEffectView.contentView.addSubview(view)
        } else {
            super.addSubview(view)
        }
    }

    public override func bringSubview(toFront view: UIView) {
        if isSmartBlurEffectEnabled {
            blurEffectView.contentView.bringSubview(toFront: view)
        } else {
            super.bringSubview(toFront: view)
        }
    }

    public override func sendSubview(toBack view: UIView) {
        if isSmartBlurEffectEnabled {
            blurEffectView.contentView.sendSubview(toBack: view)
        } else {
            super.sendSubview(toBack: view)
        }
    }
}
