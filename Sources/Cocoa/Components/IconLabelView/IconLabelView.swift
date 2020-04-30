//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class IconLabelView: XCView {
    private var imageInsetConstraints: NSLayoutConstraint.Edges!
    private var imageSizeConstraints: NSLayoutConstraint.Size!
    private var labelsWidthConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: (vertical: [NSLayoutConstraint]?, horizontal: [NSLayoutConstraint]?)

    // MARK: - Subviews

    private lazy var stackView = UIStackView(arrangedSubviews: [
        imageViewContainer,
        titleLabel
    ]).apply {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.distribution = .fillProportionally
        $0.alignment = .center
        $0.spacing = .minimumPadding / 2
        $0.sizeChangeResistance(.required, axis: .both)
    }

    public lazy var imageViewContainer = UIView().apply {
        $0.backgroundColor = imageBackgroundColor
        $0.cornerRadius = imageCornerRadius
        $0.sizeChangeResistance(.required, axis: .both)
        $0.addSubview(imageView)
    }

    public let imageView = UIImageView().apply {
        $0.isContentModeAutomaticallyAdjusted = true
        $0.enableSmoothScaling()
        $0.tintColor = .appTint
        $0.sizeChangeResistance(.required, axis: .both)
    }

    public let titleLabel = UILabel().apply {
        $0.font = .app(style: .body)
        $0.textAlignment = .center
        $0.textColor = Theme.current.textColor
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.sizeChangeResistance(.required, axis: .vertical)
    }

    public let subtitleLabel = UILabel().apply {
        $0.font = .app(style: .subheadline)
        $0.textAlignment = .center
        $0.textColor = Theme.current.textColorSecondary
        $0.numberOfLines = 0
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        $0.sizeChangeResistance(.required, axis: .vertical)
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

    /// The distance that the view is inset from the enclosing content view.
    ///
    /// The default value is `0`.
    @objc open dynamic var imageInset: UIEdgeInsets = 0 {
        didSet {
            imageInsetConstraints.update(from: imageInset)
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
        get { stackView.alignment }
        set { stackView.alignment = newValue }
    }

    /// The default value is `.minimumPadding / 2`.
    @objc open dynamic var contentInteritemSpacing: CGFloat {
        get { stackView.spacing }
        set { stackView.spacing = newValue }
    }

    /// The default value is `0`.
    @objc open dynamic var contentInset: UIEdgeInsets {
        get { stackView.layoutMargins }
        set {
            stackView.layoutMargins = newValue
            setNeedsLayout()
            layoutIfNeeded()
        }
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
        imageInsetConstraints = NSLayoutConstraint.Edges(imageView.anchor.edges.equalToSuperview().inset(imageInset).constraints)
    }

    open override func setNeedsLayout() {
        stackView.setNeedsLayout()
        super.setNeedsLayout()
    }

    open override func layoutIfNeeded() {
        stackView.layoutIfNeeded()
        super.layoutIfNeeded()
    }

    open override func layoutSubviews() {
        updateLabelsIntrinsicWidth()
        super.layoutSubviews()
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

    private func updateLabelsIntrinsicWidth() {
        [titleLabel, subtitleLabel].apply {
            $0.preferredMaxLayoutWidth = axis == .vertical ? bounds.width - contentInset.horizontal : 0
        }
    }
}

// MARK: - UIAppearance Properties

extension IconLabelView {
    @objc public dynamic var titleTextColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc public dynamic var titleFont: UIFont {
        get { titleLabel.font }
        set { titleLabel.font = newValue }
    }

    @objc public dynamic var subtitleTextColor: UIColor {
        get { subtitleLabel.textColor }
        set { subtitleLabel.textColor = newValue }
    }

    @objc public dynamic var subtitleFont: UIFont {
        get { subtitleLabel.font }
        set { subtitleLabel.font = newValue }
    }
}
