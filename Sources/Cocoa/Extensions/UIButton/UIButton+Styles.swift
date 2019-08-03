//
// UIButton+Styles.swift
//
// Copyright © 2018 Xcore
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

// MARK: - Identifier<UIButton>

extension Identifier where Type: UIButton {
    /// A style used to set base attributes that we fallback to if any of the
    /// specific style doesn't have given attribute set.
    ///
    /// ```swift
    /// UIButton.defaultAppearance.apply {
    ///     $0.styleAttributes.style(.base).setFont(.appButton())
    ///     $0.styleAttributes.style(.base).setTextColor(.appTint)
    ///
    ///     let plainStyleFont = $0.styleAttributes.style(.plain).font(button: UIButton())
    ///     // print(".appButton()", plainStyleFont == .appButton())
    ///     // true
    ///
    ///     let plainStyleTextColor = $0.styleAttributes.style(.plain).textColor(button: UIButton())
    ///     // print(".appTint", plainStyleTextColor == .appTint)
    ///     // true
    /// }
    /// ```
    public static var base: Identifier { return #function }
    public static var plain: Identifier { return #function }
    public static var callout: Identifier { return #function }
    public static var calloutSecondary: Identifier { return #function }
    public static var destructive: Identifier { return #function }
    public static var pill: Identifier { return #function }
    public static var caret: Identifier { return #function }
    public static var radioButton: Identifier { return #function }
    public static var checkbox: Identifier { return #function }
}

// MARK: - Main Styles

extension XCConfiguration where Type: UIButton {
    private static func configure(_ button: UIButton, _ id: Identifier<Type>) {
        UIButton.defaultAppearance._configureStyle?(button, id as! Identifier<UIButton>)
    }

    public static var plain: XCConfiguration {
        return .plain()
    }

    public static func plain(font: UIFont? = nil, textColor: UIColor? = nil, alignment: UIControl.ContentHorizontalAlignment = .center) -> XCConfiguration {
        let style: Identifier<Type> = .plain
        return XCConfiguration(id: style) {
            let textColor = textColor ?? style.textColor(button: $0)
            $0.titleLabel?.font = font ?? style.font(button: $0)
            $0.contentEdgeInsets = .zero
            $0.isHeightSetAutomatically = false
            $0.setTitleColor(textColor, for: .normal)
            $0.setTitleColor(textColor.alpha(textColor.alpha * 0.5), for: .highlighted)
            $0.contentHorizontalAlignment = alignment
            $0.cornerRadius = 0
            configure($0, style)
        }
    }

    public static var callout: XCConfiguration {
        return callout()
    }

    public static func callout(font: UIFont? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) -> XCConfiguration {
        let style: Identifier<Type> = .callout
        return XCConfiguration(id: style) {
            var textColor = textColor ?? style.textColor(button: $0)
            let backgroundColor = backgroundColor ?? style.backgroundColor(button: $0)

            if backgroundColor == textColor {
                textColor = backgroundColor.isLight() ? .appTint : .white
            }

            $0.titleLabel?.font = font ?? style.font(button: $0)
            $0.setTitleColor(textColor, for: .normal)
            $0.backgroundColor = backgroundColor
            $0.disabledBackgroundColor = style.disabledBackgroundColor(button: $0)
            $0.cornerRadius = style.cornerRadius
            configure($0, style)
        }
    }

    public static var calloutSecondary: XCConfiguration {
        let style: Identifier<Type> = .calloutSecondary
        return callout.extend(id: style) {
            // TODO: Need to inherit from parent without explicit check.
            if let textColor = style.textColor {
                $0.setTitleColor(textColor, for: .normal)
            }
            $0.backgroundColor = style.backgroundColor(button: $0)
            $0.disabledBackgroundColor = style.disabledBackgroundColor(button: $0)
            $0.layer.borderColor = style.borderColor(button: $0).cgColor
            configure($0, style)
        }
    }

    public static var destructive: XCConfiguration {
        let style: Identifier<Type> = .destructive
        return callout.extend(id: style) {
            $0.backgroundColor = style.backgroundColor(or: .appleRed)
            $0.disabledBackgroundColor = style.disabledBackgroundColor(button: $0)
            configure($0, style)
        }
    }

    public static var pill: XCConfiguration {
        let style: Identifier<Type> = .pill
        return callout.extend(id: style) {
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.backgroundColor = style.backgroundColor(button: $0)
            $0.disabledBackgroundColor = style.disabledBackgroundColor(button: $0)
            $0.cornerRadius = $0.defaultAppearance.height / 2
            configure($0, style)
        }
    }
}

// MARK: - Images Styles

extension XCConfiguration where Type: UIButton {
    public static var leftArrow: XCConfiguration {
        return image(assetIdentifier: .arrowLeftIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "leftButton"
        }
    }

    public static var rightArrow: XCConfiguration {
        return image(assetIdentifier: .arrowRightIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "rightButton"
        }
    }

    public static var dismiss: XCConfiguration {
        return image(assetIdentifier: .closeIcon, size: 24, axis: .horizontal, .vertical)
    }

    public static var dismissFilled: XCConfiguration {
        return image(assetIdentifier: .closeIconFilled, size: 24, axis: .horizontal, .vertical)
    }

    public static var searchIcon: XCConfiguration {
        return image(assetIdentifier: .searchIcon, size: 14, axis: .horizontal)
    }

    public static func image(
        id: String = #function,
        assetIdentifier: ImageAssetIdentifier,
        size: CGSize,
        axis: NSLayoutConstraint.Axis...
    ) -> XCConfiguration {
        return image(id: id, assetIdentifier: assetIdentifier).extend {
            $0.resistsSizeChange(axis: axis)
            // Increase the touch area if the image size is small.
            if let size = $0.image?.size, size.width < 44 || size.height < 44 {
                $0.touchAreaEdgeInsets = -10
            }
            $0.anchor.make {
                $0.size.equalTo(size).priority(.stackViewSubview)
            }
        }
    }

    public static func image(
        id: String = #function,
        assetIdentifier: ImageAssetIdentifier,
        alpha: CGFloat? = nil
    ) -> XCConfiguration {
        let style = Identifier<Type>(rawValue: id)
        return XCConfiguration {
            $0.isHeightSetAutomatically = false
            $0.text = nil
            $0.imageView?.isContentModeAutomaticallyAdjusted = true
            $0.contentTintColor = style.tintColor(button: $0)
            $0.contentEdgeInsets = .zero

            let image = UIImage(assetIdentifier: assetIdentifier)

            if let alpha = alpha {
                let originalRenderingMode = image.renderingMode
                $0.image = image.alpha(alpha).withRenderingMode(originalRenderingMode)
                $0.highlightedImage = image.alpha(alpha * 0.5).withRenderingMode(originalRenderingMode)
            } else {
                $0.image = image
            }

            configure($0, style)
        }
    }

    public static func caret(
        in configuration: XCConfiguration = .plain,
        title: String,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        direction: NSAttributedString.CaretDirection = .forward,
        animated: Bool = false
    ) -> XCConfiguration {
        let style: Identifier<Type> = .caret
        return configuration.extend(id: style) {
            let textColor = textColor ?? style.textColor(button: $0)
            let font = font ?? style.font(button: $0)
            $0.titleLabel?.numberOfLines = 1

            let attributedTitle = NSAttributedString(string: title, font: font, color: textColor, direction: direction, for: .normal)
            $0.setText(attributedTitle, animated: animated)

            let highlightedAttributedTitle = NSAttributedString(string: title, font: font, color: textColor, direction: direction, for: .highlighted)
            $0.setAttributedTitle(highlightedAttributedTitle, for: .highlighted)
            configure($0, style)
        }
    }
}

// MARK: - Toggle Styles

extension XCConfiguration where Type: UIButton {
    public static var none: XCConfiguration {
        return XCConfiguration(id: "none") { _ in }
    }

    public static var checkbox: XCConfiguration {
        return checkbox()
    }

    public static func checkbox(
        normalColor: UIColor? = nil,
        selectedColor: UIColor? = nil,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> XCConfiguration {
        let style: Identifier<Type> = .checkbox
        return XCConfiguration(id: style) {
            let normalColor = normalColor ?? style.tintColor(button: $0)
            let selectedColor = selectedColor ?? style.tintColor(button: $0)
            let textColor = textColor ?? style.textColor(button: $0)
            let font = font ?? style.font(button: $0)

            $0.accessibilityIdentifier = "checkboxButton"
            $0.textColor = textColor
            $0.titleLabel?.font = font
            $0.titleLabel?.numberOfLines = 0
            $0.contentHorizontalAlignment = .left
            $0.adjustsImageWhenHighlighted = false
            $0.adjustsBackgroundColorWhenHighlighted = false
            $0.highlightedBackgroundColor = .clear
            $0.highlightedAnimation = .none
            $0.textImageSpacing = 0
            $0.contentEdgeInsets = 0

            let unfilledImage = UIImage(assetIdentifier: .checkmarkIconUnfilled)
            let filledImage = UIImage(assetIdentifier: .checkmarkIconFilled)
            $0.setImage(unfilledImage.tintColor(normalColor), for: .normal)
            $0.setImage(filledImage.tintColor(selectedColor), for: .selected)
            configure($0, style)
        }
    }

    public static var radioButton: XCConfiguration {
        return radioButton()
    }

    public static func radioButton(
        selectedColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0.5
    ) -> XCConfiguration {
        let style: Identifier<Type> = .radioButton
        return XCConfiguration(id: style) {
            let outerWidth: CGFloat = 20
            let selectedColor = selectedColor ?? style.selectedColor(button: $0)

            $0.accessibilityIdentifier = "radioButton"
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor = style.borderColor(button: $0).cgColor
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = outerWidth / 2

            $0.anchor.make {
                $0.size.equalTo(outerWidth)
            }

            let scale: CGFloat = 0.15
            $0.image = UIImage()
            let inset = outerWidth * scale
            $0.imageView?.cornerRadius = (outerWidth - inset * 2) / 2

            $0.imageView?.anchor.make {
                $0.edges.equalToSuperview().inset(inset)
            }

            $0.didSelect { sender in
                sender.imageView?.backgroundColor = sender.isSelected ? selectedColor : .clear
            }
            configure($0, style)
        }
    }
}
