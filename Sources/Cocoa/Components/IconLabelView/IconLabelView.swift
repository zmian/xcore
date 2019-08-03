//
// IconLabelView.swift
//
// Copyright © 2015 Xcore
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
    private var imagePaddingConstraints: NSLayoutConstraint.Edges!
    private var imageSizeConstraints: NSLayoutConstraint.Size!
    private var labelsWidthConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: (vertical: [NSLayoutConstraint]?, horizontal: [NSLayoutConstraint]?)

    // MARK: - Subviews

    private lazy var stackView = UIStackView(arrangedSubviews: [
        imageViewContainer,
        titleLabel
    ]).apply {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = .minimumPadding / 2
    }

    public lazy var imageViewContainer = UIView().apply {
        $0.backgroundColor = imageBackgroundColor
        $0.cornerRadius = imageCornerRadius
        $0.addSubview(imageView)
    }

    public let imageView = UIImageView().apply {
        $0.isContentModeAutomaticallyAdjusted = true
        $0.enableSmoothScaling()
    }

    public let titleLabel = UILabel().apply {
        $0.font = .app(style: .body)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.sizeToFit()
    }

    public let subtitleLabel = UILabel().apply {
        $0.font = .app(style: .subheadline)
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        $0.sizeToFit()
    }

    /// The default value is `.vertical`.
    open var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            guard oldValue != axis else { return }
            updateAxis()
        }
    }

    /// The default size is `55`.
    @objc open dynamic var imageSize: CGSize = 55 {
        didSet {
            imageSizeConstraints.update(from: imageSize)
        }
    }

    /// The space between image and text. The default value is `0`.
    @objc open dynamic var textImageSpacing: CGFloat = 0 {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `0`, which means size to fit.
    @objc open dynamic var labelsWidth: CGFloat = 0 {
        didSet {
            guard oldValue != labelsWidth else { return }

            if labelsWidth == 0 {
                guard !labelsWidthConstraints.isEmpty else { return }
                labelsWidthConstraints.deactivate()
            } else {
                if labelsWidthConstraints.isEmpty {
                    labelsWidthConstraints.append(titleLabel.anchor.width.equalTo(labelsWidth).constraints.first!)
                    labelsWidthConstraints.append(subtitleLabel.anchor.width.equalTo(labelsWidth).constraints.first!)
                }
                labelsWidthConstraints.forEach {
                    $0.constant = labelsWidth
                }
                labelsWidthConstraints.activate()
            }
        }
    }

    /// The default value is `.minimumPadding`.
    @objc open dynamic var imagePadding: CGFloat = .minimumPadding {
        didSet {
            imageInset = UIEdgeInsets(imagePadding)
            imageView.cornerRadius = imageCornerRadius - imagePadding
        }
    }

    /// The distance that the view is inset from the enclosing content view.
    /// The default value is `.minimumPadding`.
    @objc open dynamic var imageInset: UIEdgeInsets = .minimumPadding {
        didSet {
            imagePaddingConstraints.update(from: imageInset)
        }
    }

    /// The default value is `nil`, which results in a transparent background color.
    @objc open dynamic var imageBackgroundColor: UIColor? = nil {
        didSet {
            imageViewContainer.backgroundColor = imageBackgroundColor
        }
    }

    /// The default value is `13`.
    @objc open dynamic var imageCornerRadius: CGFloat = 13 {
        didSet {
            imageViewContainer.cornerRadius = imageCornerRadius
        }
    }

    /// The default value is `false`.
    @objc open dynamic var isImageViewRounded = false {
        didSet {
            imageCornerRadius = isImageViewRounded ? imageSize.height / 2 : 0
        }
    }

    /// The default value is `true`.
    @objc open dynamic var isImageViewPrepended: Bool = true {
        didSet {
            guard oldValue != isImageViewPrepended, !isImageViewHidden else { return }

            if isImageViewPrepended {
                stackView.moveArrangedSubview(imageViewContainer, at: 0)
            } else {
                let lastIndex = stackView.arrangedSubviews.count - 1
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
                } else {
                    let lastIndex = stackView.arrangedSubviews.count - 1
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

    /// The default value is `.center`.
    open var contentAlignment: UIStackView.Alignment {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }

    /// The default value is `.minimumPadding / 2`.
    @objc open dynamic var contentPadding: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }

    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets {
        get { return stackView.layoutMargins }
        set { stackView.layoutMargins = newValue }
    }

    // MARK: - Setup Methods

    open override func commonInit() {
        addSubview(stackView)

        stackView.anchor.make {
            $0.center.equalToSuperview().priority(.defaultLow)
        }

        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self).activate()
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self).activate()

        updateAxis()

        imageSizeConstraints = NSLayoutConstraint.Size(imageViewContainer.anchor.size.equalTo(imageSize).priority(.stackViewSubview).constraints)
        imagePaddingConstraints = NSLayoutConstraint.Edges(imageView.anchor.edges.equalToSuperview().inset(imageInset).constraints)
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

// MARK: - Configure

extension IconLabelView {
    open func configure(_ image: ImageRepresentable? = nil, title: StringRepresentable?, subtitle: StringRepresentable? = nil) {
        isSubtitleLabelHidden = subtitle == nil
        isImageViewHidden = image == nil
        imageView.setImage(image)
        titleLabel.setText(title)
        subtitleLabel.setText(subtitle)
    }

    open func configure(_ data: ImageTitleDisplayable) {
        configure(data.image, title: data.title, subtitle: data.subtitle)
    }

    open func clear() {
        configure(title: nil)
    }
}

// MARK: - UIAppearance Properties

extension IconLabelView {
    @objc public dynamic var titleTextColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc public dynamic var titleFont: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }

    @objc public dynamic var subtitleTextColor: UIColor {
        get { return subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    @objc public dynamic var subtitleFont: UIFont {
        get { return subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
}

extension IconLabelView {
    private func updateAxis() {
        switch axis {
            case .vertical:
                stackView.axis = .vertical
                // Deactivate `horizontal` and activate `vertical` constraints.
                stackViewConstraints.horizontal?.deactivate()
                if stackViewConstraints.vertical == nil {
                    stackViewConstraints.vertical = stackView.anchor.horizontally.equalToSuperview().constraints
                }
                stackViewConstraints.vertical?.activate()
            case .horizontal:
                stackView.axis = .horizontal
                // Deactivate `vertical` and activate `horizontal` constraints.
                stackViewConstraints.vertical?.deactivate()
                if stackViewConstraints.horizontal == nil {
                    stackViewConstraints.horizontal = stackView.anchor.vertically.equalToSuperview().constraints
                }
                stackViewConstraints.horizontal?.activate()
            @unknown default:
                fatalError(because: .unknownCaseDetected(axis))
        }
    }

    private func updateTextImageSpacingIfNeeded() {
        guard
            stackView.arrangedSubviews.count == 2,
            let firstView = stackView.arrangedSubviews.first
        else {
            return
        }

        stackView.setCustomSpacing(textImageSpacing, after: firstView)
    }
}
