//
// UIButton+Extensions.swift
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
import ObjectiveC

@objc extension UIButton {
    // Increase button touch area to be 44 points
    // See: http://stackoverflow.com/a/27683614
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !isUserInteractionEnabled || !isEnabled || isHidden {
            return super.hitTest(point, with: event)
        }

        let buttonSize  = frame.size
        let widthToAdd  = (44 - buttonSize.width  > 0) ? 44 - buttonSize.width  : 0
        let heightToAdd = (44 - buttonSize.height > 0) ? 44 - buttonSize.height : 0
        let largerFrame = CGRect(x: 0 - (widthToAdd / 2), y: 0 - (heightToAdd / 2), width: buttonSize.width + widthToAdd, height: buttonSize.height + heightToAdd)
        return largerFrame.contains(point) ? self : nil
    }

    /// Add space between `text` and `image` while preserving the `intrinsicContentSize` and respecting `sizeToFit`.
    @IBInspectable public var textImageSpacing: CGFloat {
        get {
            let (left, right) = (imageEdgeInsets.left, imageEdgeInsets.right)

            if left + right == 0 {
                return right * 2
            } else {
                return 0
            }
        }

        set(spacing) {
            let insetAmount   = spacing / 2
            imageEdgeInsets   = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets   = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }

    /// Sets the image on **background thread** to use for the specified state.
    ///
    /// - parameter named:  The remote image url or local image name to use for the specified state.
    /// - parameter state:  The state that uses the specified image.
    /// - parameter bundle: The bundle the image file or asset catalog is located in, pass `nil` to use the main bundle.
    open func image(_ remoteOrLocalImage: String, for state: UIControlState, bundle: Bundle? = nil) {
        UIImage.remoteOrLocalImage(remoteOrLocalImage, bundle: bundle) { [weak self] image in
            self?.setImage(image, for: state)
        }
    }

    /// The image used for the normal state.
    open var image: UIImage? {
        get { return self.image(for: .normal) }
        set { setImage(newValue, for: .normal) }
    }

    /// The image used for the highlighted state.
    open var highlightedImage: UIImage? {
        get { return self.image(for: .highlighted) }
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

    /// The background color to used for the highlighted state.
    @objc open func setHighlightedBackgroundColor(_ color: UIColor?) {
        var image: UIImage?
        if let color = color {
            image = UIImage(color: color, size: CGSize(width: 1, height: 1))
        }
        setBackgroundImage(image, for: .highlighted)
    }

    /// The background color to used for the disabled state.
    @objc open func setDisabledBackgroundColor(_ color: UIColor?) {
        var image: UIImage?
        if let color = color {
            image = UIImage(color: color, size: CGSize(width: 1, height: 1))
        }
        setBackgroundImage(image, for: .disabled)
    }
}

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - parameter image:            The image to use for the normal state.
    /// - parameter highlightedImage: The image to use for the highlighted state.
    /// - parameter handler:          The block to invoke when the button is tapped.
    ///
    /// - returns: A newly created button.
    public init(image: UIImage?, highlightedImage: UIImage? = nil, handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(type: .custom)
        setImage(image, for: .normal)
        setImage(highlightedImage, for: .highlighted)
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor   = tintColor
        if let handler = handler {
            addAction(.touchUpInside, handler)
        }
    }

    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - parameter imageNamed: A string to identify a local or a remote image.
    /// - parameter handler:    The block to invoke when the button is tapped.
    ///
    /// - returns: A newly created button.
    public init(imageNamed: String, handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: nil, handler: handler)
        imageView?.remoteOrLocalImage(imageNamed) { [weak self] image in
            self?.setImage(image, for: .normal)
        }
    }
}

@objc extension UIButton {
    fileprivate struct AssociatedKey {
        static var touchAreaEdgeInsets = "XcoreTouchAreaEdgeInsets"
    }

    // http://stackoverflow.com/a/32002161

    /// Increase button touch area.
    ///
    /// ```swift
    /// let button = UIButton()
    /// button.touchAreaEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    /// ```
    open var touchAreaEdgeInsets: UIEdgeInsets {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.touchAreaEdgeInsets) as? NSValue else {
                return .zero
            }

            var edgeInsets = UIEdgeInsets.zero
            value.getValue(&edgeInsets)
            return edgeInsets
        }
        set {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &AssociatedKey.touchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(touchAreaEdgeInsets, .zero) || !isUserInteractionEnabled || !isEnabled || isHidden {
            return super.point(inside: point, with: event)
        }

        let hitFrame = UIEdgeInsetsInsetRect(bounds, touchAreaEdgeInsets)
        return hitFrame.contains(point)
    }
}
