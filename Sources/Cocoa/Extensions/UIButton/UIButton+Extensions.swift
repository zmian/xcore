//
// UIButton+Extensions.swift
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
import ObjectiveC

extension UIButton {
    /// This configuration exists to allow some of the properties
    /// to be configured to match app's appearance style.
    /// The `UIAppearance` protocol doesn't work when the stored properites
    /// are set using associated object.
    ///
    /// **For example:**
    ///
    /// ```swift
    /// // Doesn't work:
    /// UIButton.appearance().highlightedAnimation = .scale
    ///
    /// // Works as expected:
    /// UIButton.defaultAppearance.highlightedAnimation = .scale
    /// ```
    @objc(UIButtonDefaultAppearance)
    final public class DefaultAppearance: NSObject {
        public var style: Style = .none
        public var height: CGFloat = 50
        public var isHeightSetAutomatically = false
        public var highlightedAnimation: HighlightedAnimationOptions = .none
        /// The default attributes for the button styles.
        public var styleAttributes = StyleAttributes<UIButton>()

        /// A boolean value indicating whether `configureStyle` replaces existing styles
        /// block call or extend it. The default value is `true`, meaning extend.
        public var shouldExtendExistingConfigureStyle = true
        var _configureStyle: ((UIButton, Identifier<UIButton>) -> Void)?
        public func configureStyle(_ callback: @escaping (UIButton, Identifier<UIButton>) -> Void) {
            guard
                shouldExtendExistingConfigureStyle,
                let existingConfigureStyle = _configureStyle
            else {
                self._configureStyle = callback
                return
            }

            self._configureStyle = { button, id in
                existingConfigureStyle(button, id)
                callback(button, id)
            }
        }

        fileprivate override init() { }
    }
}

extension UIButton {
    fileprivate struct AssociatedKey {
        static var touchAreaEdgeInsets = "touchAreaEdgeInsets"
        static var backgroundColors = "backgroundColors"
        static var borderColors = "borderColors"
        static var didSelect = "didSelect"
        static var didHighlight = "didHighlight"
        static var didEnable = "didEnable"
        static var highlightedAnimation = "highlightedAnimation"
        static var adjustsBackgroundColorWhenHighlighted = "adjustsBackgroundColorWhenHighlighted"
        static var style = "style"
        static var heightConstraint = "heightConstraint"
        static var initialText = "initialText"
        static var isHeightSetAutomatically = "isHeightSetAutomatically"
        static var observeHeightSetAutomaticallySetter = "observeHeightSetAutomaticallySetter"
    }

    private typealias StateType = UInt

    private var backgroundColors: [StateType: UIColor] {
        get { return associatedObject(&AssociatedKey.backgroundColors, default: [:]) }
        set { setAssociatedObject(&AssociatedKey.backgroundColors, value: newValue) }
    }

    private var borderColors: [StateType: UIColor] {
        get { return associatedObject(&AssociatedKey.borderColors, default: [:]) }
        set { setAssociatedObject(&AssociatedKey.borderColors, value: newValue) }
    }

    /// A boolean property to provide visual feedback when the
    /// button is highlighted. The default value is `.none`.
    open var highlightedAnimation: HighlightedAnimationOptions {
        get { return associatedObject(&AssociatedKey.highlightedAnimation, default: defaultAppearance.highlightedAnimation) }
        set { setAssociatedObject(&AssociatedKey.highlightedAnimation, value: newValue) }
    }

    /// A boolean value that determines whether the `backgroundColor` changes when the button is highlighted.
    ///
    /// If true, the `backgroundColor` is drawn darker when the button is highlighted. The default value is `true`.
    @objc open dynamic var adjustsBackgroundColorWhenHighlighted: Bool {
        get { return associatedObject(&AssociatedKey.adjustsBackgroundColorWhenHighlighted, default: true) }
        set { setAssociatedObject(&AssociatedKey.adjustsBackgroundColorWhenHighlighted, value: newValue) }
    }
}

extension UIButton {
    @objc public dynamic static let defaultAppearance = DefaultAppearance()

    var defaultAppearance: DefaultAppearance {
        return UIButton.defaultAppearance
    }

    // MARK: - Height

    @objc public dynamic static var height: CGFloat {
        return defaultAppearance.height
    }

    /// A property to set the height of the button automatically.
    /// The default value is `false`.
    @objc open dynamic var isHeightSetAutomatically: Bool {
        get { return associatedObject(&AssociatedKey.isHeightSetAutomatically, default: defaultAppearance.isHeightSetAutomatically) }
        set {
            setAssociatedObject(&AssociatedKey.isHeightSetAutomatically, value: newValue)
            guard observeHeightSetAutomaticallySetter else { return }
            updateHeightConstraintIfNeeded()
        }
    }

    private var observeHeightSetAutomaticallySetter: Bool {
        get { return associatedObject(&AssociatedKey.observeHeightSetAutomaticallySetter, default: true) }
        set { setAssociatedObject(&AssociatedKey.observeHeightSetAutomaticallySetter, value: newValue) }
    }

    private var heightConstraint: NSLayoutConstraint? {
        get { return associatedObject(&AssociatedKey.heightConstraint) }
        set { setAssociatedObject(&AssociatedKey.heightConstraint, value: newValue) }
    }

    private func updateHeightConstraintIfNeeded() {
        guard isHeightSetAutomatically else {
            heightConstraint?.deactivate()
            return
        }

        if heightConstraint == nil {
            heightConstraint = heightAnchor.constraint(equalToConstant: UIButton.height)
            heightConstraint?.priority = .required - 1
        }

        heightConstraint?.activate()
    }

    public typealias Style = XCConfiguration<UIButton>

    /// The style of the button. The default value is `.none`.
    open var style: Style {
        get { return associatedObject(&AssociatedKey.style, default: defaultAppearance.style) }
        set {
            setAssociatedObject(&AssociatedKey.style, value: newValue)
            updateStyleIfNeeded()
        }
    }

    private var initialText: String? {
        get { return associatedObject(&AssociatedKey.initialText) }
        set { setAssociatedObject(&AssociatedKey.initialText, value: newValue) }
    }

    public convenience init(style: Style, title: String? = nil) {
        self.init(frame: .zero)
        self.style = style
        self.initialText = title
        commonInit()
    }

    private func commonInit() {
        updateStyleIfNeeded()
        if let initialText = initialText {
            self.text = initialText
        }
    }

    private func updateStyleIfNeeded() {
        observeHeightSetAutomaticallySetter = false
        contentEdgeInsets = UIEdgeInsets(horizontal: .defaultPadding)
        prepareForReuse()
        style.configure(self)
        updateHeightConstraintIfNeeded()
        observeHeightSetAutomaticallySetter = true
    }

    @objc open func prepareForReuse() {
        setAttributedTitle(nil, for: .normal)
        setTitleColor(nil, for: .highlighted)
        backgroundColor = nil
        highlightedAnimation = defaultAppearance.highlightedAnimation
        isHeightSetAutomatically = defaultAppearance.isHeightSetAutomatically
    }
}

extension UIButton {
    // MARK: Background Color

    @objc open func backgroundColor(for state: UIControl.State) -> UIColor? {
        guard let color = backgroundColors[state.rawValue] else {
            return nil
        }

        return color
    }

    @objc open func setBackgroundColor(_ backgroundColor: UIColor?, for state: UIControl.State) {
        backgroundColors[state.rawValue] = backgroundColor

        if state == .normal {
            super.backgroundColor = backgroundColor

            if adjustsBackgroundColorWhenHighlighted {
                highlightedBackgroundColor = backgroundColor?.darker(0.1)
            }
        }
    }

    private func changeBackgroundColor(to state: UIControl.State) {
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

    // MARK: Border Color

    @objc open func borderColor(for state: UIControl.State) -> UIColor? {
        guard let color = borderColors[state.rawValue] else {
            return nil
        }

        return color
    }

    @objc open func setBorderColor(_ borderColor: UIColor?, for state: UIControl.State) {
        borderColors[state.rawValue] = borderColor

        if state == .normal {
            super.layer.borderColor = borderColor?.cgColor
        }
    }

    private func changeBorderColor(to state: UIControl.State) {
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

// MARK: Convenience Aliases

extension UIButton {
    /// The image used for the normal state.
    open var image: UIImage? {
        get { return image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    /// The image used for the highlighted state.
    open var highlightedImage: UIImage? {
        get { return image(for: .highlighted) }
        set { setImage(newValue, for: .highlighted) }
    }

    /// The text used for the normal state.
    open var text: String? {
        get { return title(for: .normal) }
        set { setTitle(newValue, for: .normal) }
    }

    /// The text used for the highlighted state.
    open var highlightedText: String? {
        get { return title(for: .highlighted) }
        set { setTitle(newValue, for: .highlighted) }
    }

    /// The attributed text used for the normal state.
    open var attributedText: NSAttributedString? {
        get { return attributedTitle(for: .normal) }
        set { setAttributedTitle(newValue, for: .normal) }
    }

    /// The attributed text used for the highlighted state.
    open var highlightedAttributedText: NSAttributedString? {
        get { return attributedTitle(for: .highlighted) }
        set { setAttributedTitle(newValue, for: .highlighted) }
    }

    /// The color of the title used for the normal state.
    open var textColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }

    /// The color of the title used for the highlighted state.
    open var highlightedTextColor: UIColor? {
        get { return titleColor(for: .highlighted) }
        set { setTitleColor(newValue, for: .highlighted) }
    }

    /// The background color for the normal state.
    @objc open override var backgroundColor: UIColor? {
        get { return backgroundColor(for: .normal) }
        set { setBackgroundColor(newValue, for: .normal) }
    }

    /// The background color for the highlighted state.
    @nonobjc open var highlightedBackgroundColor: UIColor? {
        get { return backgroundColor(for: .highlighted) }
        set { setBackgroundColor(newValue, for: .highlighted) }
    }

    /// The background color for the disabled state.
    @nonobjc open var disabledBackgroundColor: UIColor? {
        get { return backgroundColor(for: .disabled) }
        set { setBackgroundColor(newValue, for: .disabled) }
    }

    /// Add space between `text` and `image` while preserving the `intrinsicContentSize` and respecting `sizeToFit`.
    @IBInspectable
    public var textImageSpacing: CGFloat {
        get {
            let (left, right) = (imageEdgeInsets.left, imageEdgeInsets.right)

            if left + right == 0 {
                return right * 2
            } else {
                return 0
            }
        }
        set {
            let insetAmount = newValue / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }

    /// Sets the image on **background thread** to use for the specified state.
    ///
    /// - Parameters:
    ///   - named:  The remote image url or local image name to use for the specified state.
    ///   - state:  The state that uses the specified image.
    public func image(_ named: ImageRepresentable?, for state: UIControl.State) {
        guard let named = named else {
            setImage(nil, for: .normal)
            return
        }

        UIImage.fetch(named) { [weak self] image in
            self?.setImage(image, for: state)
        }
    }

    // MARK: Underline

    @objc open func underline() {
        if let attributedText = titleLabel?.attributedText {
            setAttributedTitle(NSMutableAttributedString(attributedString: attributedText).underline(attributedText.string), for: .normal)
        } else if let text = titleLabel?.text {
            setAttributedTitle(NSMutableAttributedString(string: text).underline(text), for: .normal)
        }
    }

    // MARK: Reset

    @objc open func removeInsets() {
        contentEdgeInsets = 0
        titleEdgeInsets = 0
        imageEdgeInsets = 0
    }

    @objc open dynamic var contentTintColor: UIColor {
        get { return tintColor }
        set {
            tintColor = newValue
            imageView?.tintColor = newValue
        }
    }
}

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - Parameters:
    ///   - image:            The image to use for the normal state.
    ///   - highlightedImage: The image to use for the highlighted state.
    ///   - handler:          The block to invoke when the button is tapped.
    /// - Returns: A newly created button.
    public init(image: UIImage?, highlightedImage: UIImage? = nil, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(type: .custom)
        setImage(image, for: .normal)
        setImage(highlightedImage, for: .highlighted)
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = tintColor
        imageView?.enableSmoothScaling()
        if let handler = handler {
            addAction(.touchUpInside, handler)
        }
    }

    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - Parameters:
    ///   - imageNamed: A string to identify a local or a remote image.
    ///   - handler: The block to invoke when the button is tapped.
    /// - Returns: A newly created button.
    public init(imageNamed: ImageRepresentable, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: nil, handler)
        imageView?.setImage(imageNamed) { [weak self] image in
            self?.setImage(image, for: .normal)
        }
    }

    // MARK: Lifecycle Callbacks

    public func didSelect(_ callback: @escaping (_ sender: Self) -> Void) {
        didSelect = { sender in
            guard let sender = sender as? Self else { return }
            callback(sender)
        }
    }

    public func didHighlight(_ callback: @escaping (_ sender: Self) -> Void) {
        didHighlight = { sender in
            guard let sender = sender as? Self else { return }
            callback(sender)
        }
    }

    public func didEnable(_ callback: @escaping (_ sender: Self) -> Void) {
        didEnable = { sender in
            guard let sender = sender as? Self else { return }
            callback(sender)
        }
    }
}

extension UIButton {
    fileprivate var didSelect: ((_ sender: UIButton) -> Void)? {
        get { return associatedObject(&AssociatedKey.didSelect) }
        set { setAssociatedObject(&AssociatedKey.didSelect, value: newValue) }
    }

    fileprivate var didHighlight: ((_ sender: UIButton) -> Void)? {
        get { return associatedObject(&AssociatedKey.didHighlight) }
        set { setAssociatedObject(&AssociatedKey.didHighlight, value: newValue) }
    }

    fileprivate var didEnable: ((_ sender: UIButton) -> Void)? {
        get { return associatedObject(&AssociatedKey.didEnable) }
        set { setAssociatedObject(&AssociatedKey.didEnable, value: newValue) }
    }
}

extension UIButton {
    /// A convenience method to pass the `touchUpInside` event to the
    /// `UICollectionViewDelegate.didSelectItemAt` method.
    ///
    /// This convenience method omits the need to create a callback for
    /// the button and have the cell listen for it and then manually call the
    /// `didSelectItemAt` logic in multiple places.
    @objc open func forwardTouchUpInsideActionToCollectionViewDelegate() {
        addAction(.touchUpInside) { [weak self] _ in
            guard let strongSelf = self, let cell = strongSelf.collectionViewCell else { return }
            cell.select(animated: false, shouldNotifyDelegate: true)
        }
    }

    private var collectionViewCell: UICollectionViewCell? {
        return responder()
    }
}

// MARK: Hit Area

extension UIButton {
    /// Increase button touch area.
    ///
    /// ```swift
    /// let button = UIButton()
    /// button.touchAreaEdgeInsets = UIEdgeInsets(-10)
    /// ```
    /// See: http://stackoverflow.com/a/32002161
    @objc open var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            guard let value: NSValue = associatedObject(&AssociatedKey.touchAreaEdgeInsets) else {
                return 0
            }

            var edgeInsets: UIEdgeInsets = 0
            value.getValue(&edgeInsets)
            return edgeInsets
        }
        set {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            setAssociatedObject(&AssociatedKey.touchAreaEdgeInsets, value: value)
        }
    }

    @objc open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if touchAreaEdgeInsets == 0 || !isUserInteractionEnabled || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }

        let hitFrame = bounds.inset(by: touchAreaEdgeInsets)
        return hitFrame.contains(point)
    }

    // Increase button touch area to be 44 points
    // See: http://stackoverflow.com/a/27683614
    @objc open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || !isEnabled || isHidden {
            return super.hitTest(point, with: event)
        }

        let buttonSize = frame.size
        let widthToAdd = (44 - buttonSize.width  > 0) ? 44 - buttonSize.width  : 0
        let heightToAdd = (44 - buttonSize.height > 0) ? 44 - buttonSize.height : 0
        let largerFrame = CGRect(x: 0 - (widthToAdd / 2), y: 0 - (heightToAdd / 2), width: buttonSize.width + widthToAdd, height: buttonSize.height + heightToAdd)
        return largerFrame.contains(point) ? self : nil
    }
}

// MARK: Lifecycle Events

extension UIButton {
    // A method that is called when the state changes.
    @objc open func stateDidChange(_ state: UIControl.State) {
    }

    @objc private func swizzled_isSelectedSetter(newValue: Bool) {
        let oldValue = isSelected
        swizzled_isSelectedSetter(newValue: newValue)
        guard oldValue != isSelected else { return }
        stateDidChange(isSelected ? .selected : .normal)
        didSelect?(self)
    }

    @objc private func swizzled_isHighlightedSetter(newValue: Bool) {
        let oldValue = isHighlighted
        swizzled_isHighlightedSetter(newValue: newValue)
        guard oldValue != isHighlighted else { return }
        let state: UIControl.State = isHighlighted ? .highlighted : .normal
        changeBackgroundColor(to: state)
        changeBorderColor(to: state)
        stateDidChange(state)
        didHighlight?(self)
        highlightedAnimation.animate(self)
    }

    @objc private func swizzled_isEnabledSetter(newValue: Bool) {
        let oldValue = isEnabled
        swizzled_isEnabledSetter(newValue: newValue)
        guard oldValue != isEnabled else { return }
        let state: UIControl.State = isEnabled ? .normal : .disabled
        changeBackgroundColor(to: state)
        changeBorderColor(to: state)
        stateDidChange(state)
        didEnable?(self)
    }

    @objc open func setEnabled(_ enable: Bool, animated: Bool) {
        guard !animated else {
            self.isEnabled = enable
            return
        }

        UIView.performWithoutAnimation { [weak self] in
            self?.isEnabled = enable
        }
    }
}

// MARK: Swizzle

extension UIButton {
    static func runOnceSwapSelectors() {
        swizzle(
            UIButton.self,
            originalSelector: #selector(setter: UIButton.isSelected),
            swizzledSelector: #selector(UIButton.swizzled_isSelectedSetter(newValue:))
        )

        swizzle(
            UIButton.self,
            originalSelector: #selector(setter: UIButton.isHighlighted),
            swizzledSelector: #selector(UIButton.swizzled_isHighlightedSetter(newValue:))
        )

        swizzle(
            UIButton.self,
            originalSelector: #selector(setter: UIButton.isEnabled),
            swizzledSelector: #selector(UIButton.swizzled_isEnabledSetter(newValue:))
        )

        UIButton.swizzle_runOnceSwapSelectors()
    }
}
