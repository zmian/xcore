//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
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
    public static var base: Self { #function }
    public static var plain: Self { #function }
    public static var callout: Self { #function }
    public static var calloutSecondary: Self { #function }
    public static var destructive: Self { #function }
    public static var pill: Self { #function }
    public static var caret: Self { #function }
    public static var radioButton: Self { #function }
    public static var checkbox: Self { #function }
}

// MARK: - Main Configurations

extension Configuration where Type: UIButton {
    private static func configure(_ button: UIButton, _ id: Identifier) {
        UIButton.defaultAppearance._configure?(button, id as! UIButton.Configuration.Identifier)
    }

    public static var plain: Self {
        return .plain()
    }

    public static func plain(
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        alignment: UIControl.ContentHorizontalAlignment = .center
    ) -> Self {
        let id: Identifier = .plain
        return .init(id: id) {
            let textColor = textColor ?? id.textColor(button: $0)
            $0.titleLabel?.font = font ?? id.font(button: $0)
            $0.contentEdgeInsets = .zero
            $0.isHeightSetAutomatically = false
            $0.setTitleColor(textColor, for: .normal)
            $0.setTitleColor(textColor.alpha(textColor.alpha * 0.5), for: .highlighted)
            $0.contentHorizontalAlignment = alignment
            $0.cornerRadius = 0
            configure($0, id)
        }
    }

    public static var callout: Self {
        return callout()
    }

    public static func callout(
        font: UIFont? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil
    ) -> Self {
        let id: Identifier = .callout
        return .init(id: id) {
            var textColor = textColor ?? id.textColor(button: $0)
            let backgroundColor = backgroundColor ?? id.backgroundColor(button: $0)

            if backgroundColor == textColor {
                textColor = backgroundColor.isLight() ? .appTint : .white
            }

            $0.titleLabel?.font = font ?? id.font(button: $0)
            $0.setTitleColor(textColor, for: .normal)
            $0.backgroundColor = backgroundColor
            $0.disabledBackgroundColor = id.disabledBackgroundColor(button: $0)
            $0.cornerRadius = id.cornerRadius
            configure($0, id)
        }
    }

    public static var calloutSecondary: Self {
        let id: Identifier = .calloutSecondary
        return callout.extend(id: id) {
            // TODO: Need to inherit from parent without explicit check.
            if let textColor = id.textColor {
                $0.setTitleColor(textColor, for: .normal)
            }
            $0.backgroundColor = id.backgroundColor(button: $0)
            $0.disabledBackgroundColor = id.disabledBackgroundColor(button: $0)
            $0.layer.borderColor = id.borderColor(button: $0).cgColor
            configure($0, id)
        }
    }

    public static var destructive: Self {
        let id: Identifier = .destructive
        return callout.extend(id: id) {
            $0.backgroundColor = id.backgroundColor(or: .appleRed)
            $0.disabledBackgroundColor = id.disabledBackgroundColor(button: $0)
            configure($0, id)
        }
    }

    public static var pill: Self {
        let id: Identifier = .pill
        return callout.extend(id: id) {
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.titleLabel?.lineBreakMode = .byTruncatingTail
            $0.backgroundColor = id.backgroundColor(button: $0)
            $0.disabledBackgroundColor = id.disabledBackgroundColor(button: $0)
            $0.cornerRadius = $0.defaultAppearance.height / 2
            configure($0, id)
        }
    }
}

// MARK: - Images Configurations

extension Configuration where Type: UIButton {
    public static var leftArrow: Self {
        return image(assetIdentifier: .arrowLeftIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "leftButton"
        }
    }

    public static var rightArrow: Self {
        return image(assetIdentifier: .arrowRightIcon, alpha: 0.5).extend {
            $0.accessibilityIdentifier = "rightButton"
        }
    }

    public static var dismiss: Self {
        return image(assetIdentifier: .closeIcon, size: 24, axis: .horizontal, .vertical)
    }

    public static var dismissFilled: Self {
        return image(assetIdentifier: .closeIconFilled, size: 24, axis: .horizontal, .vertical)
    }

    public static var searchIcon: Self {
        return image(assetIdentifier: .searchIcon, size: 14, axis: .horizontal)
    }

    public static func image(
        id: String = #function,
        assetIdentifier: ImageAssetIdentifier,
        size: CGSize,
        axis: NSLayoutConstraint.Axis...
    ) -> Self {
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
    ) -> Self {
        let id = Identifier(rawValue: id)
        return .init {
            $0.isHeightSetAutomatically = false
            $0.text = nil
            $0.imageView?.isContentModeAutomaticallyAdjusted = true
            $0.contentTintColor = id.tintColor(button: $0)
            $0.contentEdgeInsets = .zero

            let image = UIImage(assetIdentifier: assetIdentifier)

            if let alpha = alpha {
                let originalRenderingMode = image.renderingMode
                $0.image = image.alpha(alpha).withRenderingMode(originalRenderingMode)
                $0.highlightedImage = image.alpha(alpha * 0.5).withRenderingMode(originalRenderingMode)
            } else {
                $0.image = image
            }

            configure($0, id)
        }
    }

    public static func caret(
        in configuration: Configuration = .plain,
        text: String,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        direction: NSAttributedString.CaretDirection = .forward,
        animated: Bool = false
    ) -> Self {
        let id: Identifier = .caret
        return configuration.extend(id: id) {
            let textColor = textColor ?? id.textColor(button: $0)
            let font = font ?? id.font(button: $0)
            $0.titleLabel?.numberOfLines = 1

            let attributedText = NSAttributedString(string: text, font: font, color: textColor, direction: direction, for: .normal)
            $0.setText(attributedText, animated: animated)

            let highlightedAttributedText = NSAttributedString(string: text, font: font, color: textColor, direction: direction, for: .highlighted)
            $0.setAttributedTitle(highlightedAttributedText, for: .highlighted)
            configure($0, id)
        }
    }
}

// MARK: - Toggle Configurations

extension Configuration where Type: UIButton {
    public static var none: Self {
        .init(id: #function) { _ in }
    }

    public static var checkbox: Self {
        checkbox()
    }

    public static func checkbox(
        normalColor: UIColor? = nil,
        selectedColor: UIColor? = nil,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> Self {
        let id: Identifier = .checkbox
        return .init(id: id) {
            let normalColor = normalColor ?? id.tintColor(button: $0)
            let selectedColor = selectedColor ?? id.tintColor(button: $0)
            let textColor = textColor ?? id.textColor(button: $0)
            let font = font ?? id.font(button: $0)

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
            configure($0, id)
        }
    }

    public static var radioButton: Self {
        radioButton()
    }

    public static func radioButton(
        selectedColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0.5
    ) -> Self {
        let id: Identifier = .radioButton
        return .init(id: id) {
            let outerWidth: CGFloat = 20
            let selectedColor = selectedColor ?? id.selectedColor(button: $0)

            $0.accessibilityIdentifier = "radioButton"
            $0.layer.borderWidth = borderWidth
            $0.layer.borderColor = id.borderColor(button: $0).cgColor
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
            configure($0, id)
        }
    }
}
