//
// BlurView.swift
//
// Copyright © 2017 Xcore
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
    private var style: UIBlurEffect.Style = .light
    private lazy var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
    private lazy var blurBackView = UIView().apply {
        $0.backgroundColor = blurColor
        $0.alpha = 1 - blurOpacity
    }

    /// Returns a boolean value indicating whether reduce transparency is enabled.
    ///
    /// `true` if the user has enabled Reduce Transparency in **Settings**; otherwise, `false`.
    private var isReduceTransparencyEnabled: Bool {
        return UIAccessibility.isReduceTransparencyEnabled
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

    /// A property to determine opacity for the blur effect.
    /// Use this property to soften the blur effect if needed.
    ///
    /// The default value is `1`.
    ///
    /// - Note:
    /// This property is only used when `isSmartBlurEffectEnabled` is `true`
    /// and `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurOpacity: CGFloat = 1 {
        didSet {
            blurBackView.alpha = 1 - blurOpacity
        }
    }

    /// A property to determine color for the blur effect.
    ///
    /// The default value is `.white`.
    ///
    /// - Note:
    /// This property is only used when `isSmartBlurEffectEnabled` is `true`
    /// and `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurColor: UIColor = .white {
        didSet {
            blurBackView.backgroundColor = blurColor
        }
    }

    /// The background color to use when `UIAccessibilityIsReduceTransparencyEnabled()` is `true`.
    ///
    /// The default value is `.white`.
    ///
    /// - Note:
    /// This property is only used when `isSmartBlurEffectEnabled` is `true`
    /// and `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurEffectDisabledBackgroundColor: UIColor = .white

    /// The `UIVisualEffect` to use when `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    ///
    /// The default value is `.light`.
    ///
    /// - Note:
    /// This property is only used when `isSmartBlurEffectEnabled` is `true`
    /// and `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var effect: UIVisualEffect? {
        get { return blurEffectView.effect }
        set { blurEffectView.effect = newValue }
    }

    public init(style: UIBlurEffect.Style = .light) {
        self.style = style
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func commonInit() {
        super.addSubview(blurBackView)
        super.addSubview(blurEffectView)
        blurBackView.anchor.edges.equalToSuperview()
        blurEffectView.anchor.edges.equalToSuperview()

        observer = NotificationCenter.on.accessibilityReduceTransparencyStatusDidChange { [weak self] in
            self?.accessibilityReduceTransparencyStatusDidChange()
        }

        accessibilityReduceTransparencyStatusDidChange()
    }

    deinit {
        NotificationCenter.remove(observer)
    }

    private func accessibilityReduceTransparencyStatusDidChange() {
        guard isSmartBlurEffectEnabled else {
            blurBackView.isHidden = true
            blurEffectView.isHidden = true
            backgroundColor = .clear
            return
        }

        blurBackView.isHidden = isReduceTransparencyEnabled
        blurEffectView.isHidden = isReduceTransparencyEnabled
        backgroundColor = isReduceTransparencyEnabled ? blurEffectDisabledBackgroundColor : .clear
    }
}

extension BlurView {
    public override func addSubview(_ view: UIView) {
        guard isSmartBlurEffectEnabled && !isReduceTransparencyEnabled else {
            super.addSubview(view)
            return
        }

        blurEffectView.contentView.addSubview(view)
    }

    public override func bringSubviewToFront(_ view: UIView) {
        guard isSmartBlurEffectEnabled && !isReduceTransparencyEnabled else {
            super.bringSubviewToFront(view)
            return
        }

        blurEffectView.contentView.bringSubviewToFront(view)
    }

    public override func sendSubviewToBack(_ view: UIView) {
        guard isSmartBlurEffectEnabled && !isReduceTransparencyEnabled else {
            super.sendSubviewToBack(view)
            return
        }

        blurEffectView.contentView.sendSubviewToBack(view)
    }
}
