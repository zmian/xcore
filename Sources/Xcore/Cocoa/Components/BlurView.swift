//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public class BlurView: XCView {
    private var observer: NSObjectProtocol?
    private var style: UIBlurEffect.Style = .regular
    private lazy var blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: style))
    private lazy var blurBackView = UIView().apply {
        $0.backgroundColor = blurColor
        $0.alpha = 1 - blurOpacity
    }

    /// Returns a boolean value indicating whether reduce transparency is enabled.
    ///
    /// `true` if the user has enabled Reduce Transparency in **Settings**;
    /// otherwise, `false`.
    private var isReduceTransparencyEnabled: Bool {
        UIAccessibility.isReduceTransparencyEnabled
    }

    /// A boolean property to determine whether this view automatically enables blur
    /// effect. When this property is `false` this classs acts as normal `UIView`.
    ///
    /// The default value is `true`.
    ///
    /// - Note: When this property is `true` it only enables blur effect when
    ///   `UIAccessibilityIsReduceTransparencyEnabled()` is `false`; otherwise,
    ///   `blurEffectDisabledBackgroundColor` value is used instead of the blur
    ///   effect.
    public var isBlurEffectEnabled = true {
        didSet {
            guard oldValue != isBlurEffectEnabled else { return }
            accessibilityReduceTransparencyStatusDidChange()
        }
    }

    /// A property to determine opacity for the blur effect. Use this property to
    /// soften the blur effect if needed.
    ///
    /// The default value is `1`.
    ///
    /// - Note: This property is only used when `isBlurEffectEnabled` is `true` and
    ///   `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurOpacity: CGFloat = 1 {
        didSet {
            blurBackView.alpha = 1 - blurOpacity
        }
    }

    /// A property to determine color for the blur effect.
    ///
    /// The default value is `Theme.backgroundColor`.
    ///
    /// - Note: This property is only used when `isBlurEffectEnabled` is `true` and
    ///   `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurColor: UIColor = Theme.backgroundColor {
        didSet {
            blurBackView.backgroundColor = blurColor
        }
    }

    /// The background color to use when
    /// `UIAccessibilityIsReduceTransparencyEnabled()` is `true`.
    ///
    /// The default value is `Theme.backgroundColor`.
    ///
    /// - Note: This property is only used when `isBlurEffectEnabled` is `true` and
    ///   `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var blurEffectDisabledBackgroundColor: UIColor = Theme.backgroundColor

    /// The `UIVisualEffect` to use when
    /// `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    ///
    /// The default value is `.regular`.
    ///
    /// - Note: This property is only used when `isBlurEffectEnabled` is `true` and
    ///   `UIAccessibilityIsReduceTransparencyEnabled()` is `false`.
    @objc public dynamic var effect: UIVisualEffect? {
        get { blurEffectView.effect }
        set { blurEffectView.effect = newValue }
    }

    public init(style: UIBlurEffect.Style = .regular) {
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
        guard isBlurEffectEnabled else {
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
        guard isBlurEffectEnabled, !isReduceTransparencyEnabled else {
            super.addSubview(view)
            return
        }

        blurEffectView.contentView.addSubview(view)
    }

    public override func bringSubviewToFront(_ view: UIView) {
        guard isBlurEffectEnabled, !isReduceTransparencyEnabled else {
            super.bringSubviewToFront(view)
            return
        }

        blurEffectView.contentView.bringSubviewToFront(view)
    }

    public override func sendSubviewToBack(_ view: UIView) {
        guard isBlurEffectEnabled, !isReduceTransparencyEnabled else {
            super.sendSubviewToBack(view)
            return
        }

        blurEffectView.contentView.sendSubviewToBack(view)
    }
}
