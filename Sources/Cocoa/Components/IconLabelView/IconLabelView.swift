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

open class IconLabelView: XCView {
    public enum Style { case topBottom, leftRight }

    private var imagePaddingConstraints: [NSLayoutConstraint] = []
    private var imageSizeConstraints: (width: NSLayoutConstraint?, height: NSLayoutConstraint?)
    private var labelsWidthConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: (topBottom: [NSLayoutConstraint]?, leftRight: [NSLayoutConstraint]?)

    // MARK: Subviews

    private let stackView = UIStackView()
    private let textImageSpacerView = IntrinsicContentSizeView()
    public let imageViewContainer = UIView()
    public let imageView = UIImageView()
    public let titleLabel = UILabel()
    public let subtitleLabel = UILabel()

    /// The default value is `Style.topBottom`.
    open var style = Style.topBottom {
        didSet {
            guard oldValue != style else { return }
            apply(style: style)
        }
    }

    /// The default size is `55,55`.
    @objc open dynamic var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            imageSizeConstraints.width?.constant = imageSize.width
            imageSizeConstraints.height?.constant = imageSize.height
        }
    }

    /// The space between image and text. The default value is `0`.
    @objc open dynamic var textImageSpacing: CGFloat = 0 {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `0` which means size to fit.
    @objc open dynamic var labelsWidth: CGFloat = 0 {
        didSet {
            guard oldValue != labelsWidth else { return }

            if labelsWidth == 0 {
                guard !labelsWidthConstraints.isEmpty else { return }
                labelsWidthConstraints.deactivate()
            } else {
                if labelsWidthConstraints.isEmpty {
                    labelsWidthConstraints.append(NSLayoutConstraint(item: titleLabel, width: labelsWidth))
                    labelsWidthConstraints.append(NSLayoutConstraint(item: subtitleLabel, width: labelsWidth))
                }
                labelsWidthConstraints.forEach {
                    $0.constant = labelsWidth
                }
                labelsWidthConstraints.activate()
            }
        }
    }

    /// The default value is `8`.
    @objc open dynamic var imagePadding: CGFloat = 8 {
        didSet {
            imageInset = UIEdgeInsets(imagePadding)
            imageView.cornerRadius = imageCornerRadius - imagePadding
        }
    }

    /// The distance that the view is inset from the enclosing content view.
    /// The default value is `UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)`.
    @objc open dynamic var imageInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            imagePaddingConstraints.at(0)?.constant = imageInset.top
            imagePaddingConstraints.at(1)?.constant = imageInset.bottom
            imagePaddingConstraints.at(2)?.constant = imageInset.left
            imagePaddingConstraints.at(3)?.constant = imageInset.right
        }
    }

    /// The default value is `13`.
    @objc open dynamic var imageCornerRadius: CGFloat = 13 {
        didSet {
            imageViewContainer.cornerRadius = imageCornerRadius
        }
    }

    /// The default value is `false`.
    @objc open dynamic var isRoundImageView = false {
        didSet {
            imageCornerRadius = isRoundImageView ? imageSize.height / 2 : 0
        }
    }

    /// The default value is `nil`, which results in a transparent background color.
    @objc open dynamic var imageBackgroundColor: UIColor? = nil {
        didSet {
            imageViewContainer.backgroundColor = imageBackgroundColor
        }
    }

    /// The default value is `true`.
    @objc open dynamic var isImageViewPrepended: Bool = true {
        didSet {
            guard oldValue != isImageViewPrepended, !isImageViewHidden else { return }

            if isImageViewPrepended {
                stackView.moveArrangedSubview(imageViewContainer, at: 0)
                stackView.moveArrangedSubview(textImageSpacerView, at: 1)
            } else {
                var lastIndex: Int { return stackView.arrangedSubviews.count - 1 }
                stackView.moveArrangedSubview(textImageSpacerView, at: lastIndex)
                stackView.moveArrangedSubview(imageViewContainer, at: lastIndex)
            }

            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `false`.
    @objc open dynamic var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }

            if isImageViewHidden {
                stackView.removeArrangedSubview(imageViewContainer)
                imageViewContainer.removeFromSuperview()
            } else {
                if isImageViewPrepended {
                    stackView.insertArrangedSubview(imageViewContainer, at: 0)
                    stackView.moveArrangedSubview(textImageSpacerView, at: 1)
                } else {
                    var lastIndex: Int { return stackView.arrangedSubviews.count - 1 }
                    stackView.moveArrangedSubview(textImageSpacerView, at: lastIndex)
                    stackView.insertArrangedSubview(imageViewContainer, at: lastIndex)
                }
            }

            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `true`.
    @objc open dynamic var isSubtitleLabelHidden: Bool = true {
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
    private var distribution: UIStackViewDistribution {
        get { return stackView.distribution }
        set { stackView.distribution = newValue }
    }

    /// The default value is `.Center`.
    open var alignment: UIStackViewAlignment {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }

    /// The default value is `5`.
    @objc open dynamic var spacing: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }

    /// The default value is `.zero`.
    @objc open dynamic var contentInset: UIEdgeInsets {
        get { return stackView.layoutMargins }
        set { stackView.layoutMargins = newValue }
    }

    // MARK: Setters

    open func setData(_ image: ImageRepresentable? = nil, title: StringRepresentable?, subtitle: StringRepresentable? = nil) {
        isSubtitleLabelHidden = subtitle == nil
        isImageViewHidden = image == nil
        imageView.setImage(image)
        titleLabel.setText(title)
        subtitleLabel.setText(subtitle)
    }

    open func setData(_ data: ImageTitleDisplayable) {
        setData(data.image, title: data.title, subtitle: data.subtitle)
    }

    // MARK: Setup Methods

    open override func commonInit() {
        addSubview(stackView)

        NSLayoutConstraint.center(stackView, priority: .defaultLow).activate()
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self).activate()
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self).activate()

        apply(style: style)
        distribution = .fill
        alignment = .center
        spacing = 5

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.addArrangedSubview(imageViewContainer)
        stackView.addArrangedSubview(textImageSpacerView)
        stackView.addArrangedSubview(titleLabel)

        titleLabel.font = .systemFont(.footnote)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.sizeToFit()

        subtitleLabel.font = .systemFont(.footnote)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .lightGray
        subtitleLabel.numberOfLines = 1
        subtitleLabel.sizeToFit()

        imageViewContainer.backgroundColor = imageBackgroundColor
        imageViewContainer.cornerRadius = imageCornerRadius
        imageViewContainer.addSubview(imageView)
        let size = NSLayoutConstraint.size(imageViewContainer, size: imageSize).activate()
        imageSizeConstraints.width = size[0]
        imageSizeConstraints.height = size[1]
        imagePaddingConstraints = NSLayoutConstraint.constraintsForViewToFillSuperview(imageView, padding: imageInset).activate()

        // Ensures smooth scaling quality
        imageView.layer.minificationFilter = kCAFilterTrilinear

        imageView.contentMode = .scaleAspectFill
    }

    open override func setNeedsLayout() {
        stackView.setNeedsLayout()
        super.setNeedsLayout()
    }

    open override func layoutIfNeeded() {
        stackView.layoutIfNeeded()
        super.layoutIfNeeded()
    }
}

// MARK: UIAppearance Properties

extension IconLabelView {
    @objc public dynamic var titleColor: UIColor? {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    @objc public dynamic var subtitleColor: UIColor? {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    @objc public dynamic var subtitleFont: UIFont {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
}

extension IconLabelView {
    private func apply(style: Style) {
        switch style {
            case .topBottom:
                axis = .vertical
                // Deactivate `LeftRight` and activate `TopBottom` constraints.
                stackViewConstraints.leftRight?.deactivate()
                if stackViewConstraints.topBottom == nil {
                    stackViewConstraints.topBottom = NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(stackView)
                }
                stackViewConstraints.topBottom?.activate()
            case .leftRight:
                axis = .horizontal
                // Deactivate `TopBottom` and activate `LeftRight` constraints.
                stackViewConstraints.topBottom?.deactivate()
                if stackViewConstraints.leftRight == nil {
                    stackViewConstraints.leftRight = NSLayoutConstraint.constraintsForViewToFillSuperviewVertical(stackView)
                }
                stackViewConstraints.leftRight?.activate()
        }
    }

    private func updateTextImageSpacingIfNeeded() {
        let spacing = isImageViewHidden ? 0 : textImageSpacing
        textImageSpacerView.contentSize = CGSize(width: 0, height: spacing)
    }
}
