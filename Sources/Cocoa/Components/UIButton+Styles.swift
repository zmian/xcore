//
// UIButton+Styles.swift
//
// Copyright © 2018 Zeeshan Mian
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

extension Identifier where Type: UIButton {
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

extension XCConfiguration where Type: UIButton {
    static var styleAttributes: StyleAttributes<UIButton> {
        return UIButton.defaultAppearance.styleAttributes
    }

    public static var plain: XCConfiguration {
        return .plain()
    }

    public static func plain(font: UIFont? = nil, textColor: UIColor? = nil, alignment: UIControl.ContentHorizontalAlignment = .center) -> XCConfiguration {
        return XCConfiguration(identifier: .plain) {
            let textColor = textColor ?? $0.default.textColor(button: $0)
            $0.titleLabel?.font = font ?? $0.default.font(button: $0)
            $0.contentEdgeInsets = .zero
            $0.isHeightSetAutomatically = false
            $0.setTitleColor(textColor, for: .normal)
            $0.setTitleColor(textColor.alpha(textColor.alpha * 0.5), for: .highlighted)
            $0.contentHorizontalAlignment = alignment
            $0.cornerRadius = 0
        }
    }

    public static var callout: XCConfiguration {
        return callout()
    }

    public static func callout(font: UIFont? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) -> XCConfiguration {
        return XCConfiguration(identifier: .callout) {
            $0.titleLabel?.font = font ?? $0.default.font(button: $0)
            $0.setTitleColor(textColor ?? .white, for: .normal)
            $0.backgroundColor = backgroundColor ?? $0.default.backgroundColor(button: $0)
            $0.disabledBackgroundColor = .backgroundDisabled
            $0.cornerRadius = $0.default.cornerRadius
        }
    }

    public static var calloutSecondary: XCConfiguration {
        return callout.extend(identifier: .calloutSecondary) {
            $0.backgroundColor = $0.default.backgroundColor(button: $0)
        }
    }

    public static var destructive: XCConfiguration {
        return callout.extend(identifier: .destructive) {
            $0.backgroundColor = $0.default.backgroundColor(button: $0)
        }
    }

    public static var pill: XCConfiguration {
        return callout.extend(identifier: .pill) {
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.backgroundColor = $0.default.backgroundColor(button: $0)
            $0.cornerRadius = UIButton.defaultAppearance.height / 2
        }
    }
}

// MARK: - Main Styles

extension XCConfiguration where Type: UIButton {
    public static var dismiss: XCConfiguration {
        return image(assetIdentifier: .closeIcon, size: 22, axis: .horizontal, .vertical)
    }

    public static var dismissFilled: XCConfiguration {
        return XCConfiguration(identifier: "dismissFilled") {
            $0.image = UIImage(assetIdentifier: .closeIconFilled)
            $0.contentTintColor = $0.tintColor
        }
    }

    public static var searchIcon: XCConfiguration {
        return image(assetIdentifier: .searchIcon, size: 14, axis: .horizontal)
    }

    public static func image(
        assetIdentifier: ImageAssetIdentifier,
        size: CGSize,
        identifier: String = #function,
        axis: NSLayoutConstraint.Axis...
    ) -> XCConfiguration {
        return XCConfiguration(identifier: identifier) {
            $0.isHeightSetAutomatically = false
            $0.text = nil
            $0.image = UIImage(assetIdentifier: assetIdentifier)
            $0.imageView?.isContentModeAutomaticallyAdjusted = true
            $0.contentTintColor = $0.tintColor
            $0.contentEdgeInsets = .zero
            $0.resistsSizeChange(axis: axis)
            $0.touchAreaEdgeInsets = -10
            $0.anchor.make {
                $0.size.equalTo(size)
            }
        }
    }

    public static func image(assetIdentifier: ImageAssetIdentifier, alpha: CGFloat) -> XCConfiguration {
        return XCConfiguration {
            $0.isHeightSetAutomatically = false
            let image = UIImage(assetIdentifier: assetIdentifier)
            $0.image = image.alpha(alpha).withRenderingMode(.alwaysTemplate)
            $0.highlightedImage = image.alpha(alpha * 0.5).withRenderingMode(.alwaysTemplate)
        }
    }

    public static var leftArrow: XCConfiguration {
        return XCConfiguration.image(assetIdentifier: .arrowLeftIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "leftButton"
        }
    }

    public static var rightArrow: XCConfiguration {
        return XCConfiguration.image(assetIdentifier: .arrowRightIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "rightButton"
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
        return configuration.extend(identifier: .caret) {
            let textColor = textColor ?? $0.default.textColor(button: $0)
            let font = font ?? $0.default.font(button: $0)
            $0.titleLabel?.numberOfLines = 1

            let attributedTitle = NSAttributedString(string: title, font: font, color: textColor, direction: direction, for: .normal)
            $0.setText(attributedTitle, animated: animated)

            let highlightedAttributedTitle = NSAttributedString(string: title, font: font, color: textColor, direction: direction, for: .highlighted)
            $0.setAttributedTitle(highlightedAttributedTitle, for: .highlighted)
        }
    }
}

// MARK: - Toggle Styles

extension XCConfiguration where Type: UIButton {
    public static var none: XCConfiguration {
        return XCConfiguration(identifier: "none") { _ in }
    }

    public static var checkbox: XCConfiguration {
        return checkbox()
    }

    public static func checkbox(normalColor: UIColor? = nil, selectedColor: UIColor? = nil, textColor: UIColor? = nil, font: UIFont? = nil) -> XCConfiguration {
        return XCConfiguration(identifier: .checkbox) {
            let normalColor = normalColor ?? $0.default.tintColor(button: $0)
            let selectedColor = selectedColor ?? $0.default.tintColor(button: $0)
            let textColor = textColor ?? $0.default.textColor(button: $0)
            let font = font ?? $0.default.font(button: $0)

            $0.accessibilityIdentifier = "checkboxButton"
            $0.textColor = textColor
            $0.titleLabel?.font = font
            $0.titleLabel?.numberOfLines = 0
            $0.textImageSpacing = .minimumPadding
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
        }
    }

    public static var radioButton: XCConfiguration {
        return radioButton()
    }

    public static func radioButton(selectedColor: UIColor? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat = 0.5) -> XCConfiguration {
        return XCConfiguration(identifier: .radioButton) {
            let outerWidth: CGFloat = 20
            let selectedColor = selectedColor ?? $0.default.selectedColor(button: $0)

            $0.accessibilityIdentifier = "radioButton"
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor = $0.default.borderColor(button: $0).cgColor
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
        }
    }
}
