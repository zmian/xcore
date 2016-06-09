//
// IconLabelView.swift
//
// Copyright © 2015 Zeeshan Mian
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
import TZStackView

public class IconLabelView: UIView {
    public enum Style { case topBottom, leftRight }

    private var imagePaddingConstraints: [NSLayoutConstraint] = []
    private var imageSizeConstraints: (width: NSLayoutConstraint?, height: NSLayoutConstraint?)
    private var labelsWidthConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: (topBottom: [NSLayoutConstraint]?, leftRight: [NSLayoutConstraint]?)

    // MARK: Subviews

    private let stackView           = TZStackView()
    private let textImageSpacerView = IntrinsicContentSizeView()
    public let imageViewContainer   = UIView()
    public let imageView            = UIImageView()
    public let titleLabel           = UILabel()
    public let subtitleLabel        = UILabel()

    /// The default value is `Style.topBottom`.
    public var style = Style.topBottom {
        didSet {
            guard oldValue != style else { return }
            updateStyle(style)
        }
    }

    /// The default size is `55,55`.
    public dynamic var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            imageSizeConstraints.width?.constant  = imageSize.width
            imageSizeConstraints.height?.constant = imageSize.height
        }
    }

    /// The space between image and text. The default value is `0`.
    public dynamic var textImageSpacing: CGFloat = 0 {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `0` which means size to fit.
    public dynamic var labelsWidth: CGFloat = 0 {
        didSet {
            guard oldValue != labelsWidth else { return }
            if labelsWidth == 0 {
                guard !labelsWidthConstraints.isEmpty else { return }
                labelsWidthConstraints.deactivate()
            } else {
                if labelsWidthConstraints.isEmpty {
                    labelsWidthConstraints.append(NSLayoutConstraint(item: titleLabel,    width: labelsWidth))
                    labelsWidthConstraints.append(NSLayoutConstraint(item: subtitleLabel, width: labelsWidth))
                }
                labelsWidthConstraints.activate()
            }
        }
    }

    /// The default value is `8`.
    public dynamic var imagePadding: CGFloat = 8 {
        didSet {
            imageInset = UIEdgeInsets(all: imagePadding)
            imageView.cornerRadius = imageCornerRadius - imagePadding
        }
    }

    /// The distance that the view is inset from the enclosing content view.
    /// The default value is `UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)`.
    public dynamic var imageInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            imagePaddingConstraints.at(0)?.constant = imageInset.top
            imagePaddingConstraints.at(1)?.constant = imageInset.bottom
            imagePaddingConstraints.at(2)?.constant = imageInset.left
            imagePaddingConstraints.at(3)?.constant = imageInset.right
        }
    }

    /// The default value is `13`.
    public dynamic var imageCornerRadius: CGFloat = 13 {
        didSet {
            imageViewContainer.cornerRadius = imageCornerRadius
        }
    }

    /// The default value is `false`.
    public dynamic var isRoundImageView = false {
        didSet {
            imageCornerRadius = isRoundImageView ? imageSize.height / 2 : 0
        }
    }

    /// The default value is `nil`, which results in a transparent background color.
    public dynamic var imageBackgroundColor: UIColor? = nil {
        didSet {
            imageViewContainer.backgroundColor = imageBackgroundColor
        }
    }

    /// The default value is `false`.
    public dynamic var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            if isImageViewHidden {
                stackView.removeArrangedSubview(imageViewContainer)
                imageViewContainer.removeFromSuperview()
            } else {
                stackView.insertArrangedSubview(imageViewContainer, atIndex: 0)
            }
        }
    }

    /// The default value is `true`.
    public dynamic var isSubtitleLabelHidden: Bool = true {
        didSet {
            guard oldValue != isSubtitleLabelHidden else { return }
            if isSubtitleLabelHidden {
                stackView.removeArrangedSubview(subtitleLabel)
                subtitleLabel.removeFromSuperview()
            } else {
                stackView.addArrangedSubview(subtitleLabel)
            }
        }
    }

    /// The default value is `.Vertical`.
    private var axis: UILayoutConstraintAxis {
        get { return stackView.axis }
        set { stackView.axis = newValue }
    }

    /// The default value is `.Fill`.
    private var distribution: TZStackViewDistribution {
        get { return stackView.distribution }
        set { stackView.distribution = newValue }
    }

    /// The default value is `.Center`.
    public var alignment: TZStackViewAlignment {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }

    /// The default value is `5`.
    public dynamic var spacing: CGFloat {
        get { return stackView.spacing }
        set {
            stackView.spacing = newValue
            // Bug in TZStackView
            stackView.invalidateIntrinsicContentSize()
        }
    }

    // MARK: Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    // MARK: Setters

    public func setData(image: ImageRepresentable? = nil, title: StringRepresentable, subtitle: StringRepresentable? = nil) {
        isSubtitleLabelHidden = subtitle == nil
        isImageViewHidden     = image == nil
        imageView.setImage(image)
        titleLabel.setText(title)
        subtitleLabel.setText(subtitle)
    }

    public func setData(data: ImageTitleDisplayable) {
        setData(data.image, title: data.title, subtitle: data.subtitle)
    }

    // MARK: Setup Methods

    private func setupSubviews() {
        addSubview(stackView)
        NSLayoutConstraint.centerXY(stackView).activate()
        NSLayoutConstraint.constraintsForViewToFillSuperview(stackView, priority: UILayoutPriorityDefaultLow).activate()

        updateStyle(style)
        distribution = .Fill
        alignment    = .Center
        spacing      = 5

        stackView.addArrangedSubview(imageViewContainer)
        stackView.addArrangedSubview(textImageSpacerView)
        stackView.addArrangedSubview(titleLabel)

        titleLabel.font          = UIFont.systemFont(.footnote)
        titleLabel.textAlignment = .Center
        titleLabel.textColor     = UIColor.blackColor()
        titleLabel.numberOfLines = 2
        titleLabel.sizeToFit()

        subtitleLabel.font          = UIFont.systemFont(.footnote)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor     = UIColor.lightGrayColor()
        subtitleLabel.numberOfLines = 1
        subtitleLabel.sizeToFit()

        imageViewContainer.backgroundColor = imageBackgroundColor
        imageViewContainer.cornerRadius    = imageCornerRadius
        imageViewContainer.addSubview(imageView)
        let size = NSLayoutConstraint.size(imageViewContainer, size: imageSize).activate()
        imageSizeConstraints.width  = size[0]
        imageSizeConstraints.height = size[1]
        imagePaddingConstraints = NSLayoutConstraint.constraintsForViewToFillSuperview(imageView, padding: imageInset).activate()

        // Ensures smooth scaling quality
        imageView.layer.minificationFilter = kCAFilterTrilinear

        imageView.contentMode = .ScaleAspectFill
    }

    private func updateStyle(style: Style) {
        switch style {
            case .topBottom:
                axis = .Vertical
                // Deactivate `LeftRight` and activate `TopBottom` constraints.
                stackViewConstraints.leftRight?.deactivate()
                if stackViewConstraints.topBottom == nil {
                    stackViewConstraints.topBottom = NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(stackView)
                }
                stackViewConstraints.topBottom?.activate()
            case .leftRight:
                axis = .Horizontal
                // Deactivate `TopBottom` and activate `LeftRight` constraints.
                stackViewConstraints.topBottom?.deactivate()
                if stackViewConstraints.leftRight == nil {
                    stackViewConstraints.leftRight = NSLayoutConstraint.constraintsForViewToFillSuperviewVertical(stackView)
                }
                stackViewConstraints.leftRight?.activate()
        }
    }

    // MARK: Helpers

    private func updateTextImageSpacingIfNeeded() {
        let spacing = isImageViewHidden ? 0 : textImageSpacing
        textImageSpacerView.contentSize = CGSize(width: 0, height: spacing)
    }
}

// MARK: UIAppearance Properties

public extension IconLabelView {
    public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    public dynamic var subtitleColor: UIColor? {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    public dynamic var subtitleFont: UIFont {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
}
