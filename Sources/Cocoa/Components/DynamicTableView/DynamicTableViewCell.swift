//
// DynamicTableViewCell.swift
//
// Copyright © 2016 Zeeshan Mian
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

open class DynamicTableViewCell: XCTableViewCell {
    private var data: DynamicTableModel!
    private let padding: CGFloat = 15
    private var imageAndTitleSpacingConstraint: NSLayoutConstraint?
    private var imageSizeConstraints: (width: NSLayoutConstraint?, height: NSLayoutConstraint?)
    private var contentConstraints: (top: NSLayoutConstraint?, left: NSLayoutConstraint?, bottom: NSLayoutConstraint?, right: NSLayoutConstraint?)
    private var minimumContentHeightConstraint: NSLayoutConstraint?
    private var labelsStackViewConstraints: (top: NSLayoutConstraint?, bottom: NSLayoutConstraint?)

    /// The distance that the view is inset from the enclosing content view.
    /// The default value is `UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15)`.
    @objc open dynamic var contentInset = UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15) {
        didSet {
            contentConstraints.top?.constant = contentInset.top
            contentConstraints.left?.constant = contentInset.left
            contentConstraints.bottom?.constant = contentInset.bottom
            contentConstraints.right?.constant = contentInset.right

            // Update stack view constraints
            labelsStackViewConstraints.top?.constant = contentInset.top
            labelsStackViewConstraints.bottom?.constant = contentInset.bottom
        }
    }

    /// The default value is `44`.
    @objc open dynamic var minimumContentHeight: CGFloat = 44 {
        didSet {
            minimumContentHeightConstraint?.constant = minimumContentHeight
        }
    }

    /// The default size is `55,55`.
    @objc open dynamic var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            updateImageSizeIfNeeded()
        }
    }

    /// The space between image and text. The default value is `8`.
    @objc open dynamic var textImageSpacing: CGFloat = 8 {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The space between `title` and `subtitle` labels. The default value is `3`.
    @objc open dynamic var interLabelSpacing: CGFloat {
        get { return labelsStackView.spacing }
        set { labelsStackView.spacing = newValue }
    }

    /// The default value is `false`.
    @objc open dynamic var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            avatarView.isHidden = isImageViewHidden
            updateImageSizeIfNeeded()
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `false`.
    @objc open dynamic var isSubtitleLabelHidden: Bool = false {
        didSet {
            guard oldValue != isSubtitleLabelHidden else { return }
            if isSubtitleLabelHidden {
                labelsStackView.removeArrangedSubview(subtitleLabel)
                subtitleLabel.removeFromSuperview()
            } else {
                labelsStackView.addArrangedSubview(subtitleLabel)
            }
        }
    }

    /// The default value is `true`.
    @objc open dynamic var isRoundImageView = true {
        didSet { roundAvatarViewCornersIfNeeded() }
    }

    /// The background color of the cell when it is highlighted.
    @objc open dynamic var highlightedBackgroundColor: UIColor?
    private var normalBackgroundColor: UIColor?
    private var observeBackgroundColorSetter = true
    open override var backgroundColor: UIColor? {
        didSet {
            if observeBackgroundColorSetter {
                normalBackgroundColor = backgroundColor
            }
        }
    }

    private var onHighlight: ((_ highlighted: Bool, _ animated: Bool) -> Void)?
    open func onHighlight(_ callback: @escaping (_ highlighted: Bool, _ animated: Bool) -> Void) {
        onHighlight = callback
    }

    private var onSelect: ((_ selected: Bool, _ animated: Bool) -> Void)?
    open func onSelect(_ callback: @escaping (_ selected: Bool, _ animated: Bool) -> Void) {
        onSelect = callback
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        onSelect?(selected, animated)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if let highlightedBackgroundColor = highlightedBackgroundColor {
            observeBackgroundColorSetter = false
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundColor = highlighted ? highlightedBackgroundColor : self.normalBackgroundColor
            }, completion: { _ in
                self.observeBackgroundColorSetter = true
            })
        }
        onHighlight?(highlighted, animated)
    }

    // MARK: UITableViewCellStateMask

    private var willTransitionToState: ((_ state: UITableViewCell.StateMask) -> Void)?
    @nonobjc open func willTransitionToState(_ callback: @escaping (_ state: UITableViewCell.StateMask) -> Void) {
        willTransitionToState = callback
    }
    open override func willTransition(to state: UITableViewCell.StateMask) {
        super.willTransition(to: state)
        willTransitionToState?(state)
    }

    private var didTransitionToState: ((_ state: UITableViewCell.StateMask) -> Void)?
    @nonobjc open func didTransitionToState(_ callback: @escaping (_ state: UITableViewCell.StateMask) -> Void) {
        didTransitionToState = callback
    }
    open override func didTransition(to state: UITableViewCell.StateMask) {
        super.didTransition(to: state)
        didTransitionToState?(state)
    }

    // MARK: Subviews

    private let labelsStackView = UIStackView()
    public let avatarView = UIImageView()
    public let titleLabel = UILabel()
    public let subtitleLabel = UILabel()

    // MARK: Setters

    open func setData(_ data: DynamicTableModel) {
        self.data = data
        isImageViewHidden = data.image == nil
        isSubtitleLabelHidden = data.subtitle == nil
        titleLabel.setText(data.title)
        subtitleLabel.setText(data.subtitle)
        avatarView.setImage(data.image)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        separatorInset = .zero
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// This method is called when `UITableView` invokes `tableView:willDisplayCell:forRowAtIndexPath:` delegate method.
    open func cellWillAppear(_ indexPath: IndexPath, data: DynamicTableModel) {}

    // MARK: Setup Methods

    open override func commonInit() {
        clipsToBounds = true
        backgroundColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
        setupAvatarView()
        setupLabels()
        setupConstraints()
    }

    private func setupAvatarView() {
        contentView.addSubview(avatarView)
        avatarView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true

        // Border
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.black.alpha(0.08).cgColor

        roundAvatarViewCornersIfNeeded()
        avatarView.enableSmoothScaling()
    }

    private func setupLabels() {
        contentView.addSubview(labelsStackView)

        labelsStackView.axis = .vertical
        labelsStackView.spacing = 3

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)

        // TitleLabel
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        // SubtitleLabel
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textAlignment = .left
        subtitleLabel.textColor = .lightGray // This is ignored if NSAttributedText declares it's own color
        subtitleLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for Labels Stack View
        labelsStackViewConstraints.top = NSLayoutConstraint(item: labelsStackView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: contentView, constant: contentInset.top).activate()
        labelsStackViewConstraints.bottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: labelsStackView, constant: contentInset.bottom).activate()
        NSLayoutConstraint.centerY(labelsStackView).activate()

        // Avatar size
        let size = NSLayoutConstraint.size(avatarView, size: imageSize).activate()
        imageSizeConstraints.width = size[0]
        imageSizeConstraints.height = size[1]

        // Avatar Center
        NSLayoutConstraint.centerY(avatarView).activate()

        imageAndTitleSpacingConstraint = NSLayoutConstraint(item: labelsStackView, attribute: .leading, toItem: avatarView, attribute: .trailing, constant: textImageSpacing).activate()

        // Content Constraints
        contentConstraints.left = NSLayoutConstraint(item: avatarView, attribute: .leading, toItem: contentView, constant: contentInset.left).activate()
        contentConstraints.right = NSLayoutConstraint(item: contentView, attribute: .trailing, toItem: labelsStackView, constant: contentInset.right).activate()
        contentConstraints.top = NSLayoutConstraint(item: avatarView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: contentView, constant: contentInset.top, priority: .defaultHigh).activate()
        contentConstraints.bottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: avatarView, constant: contentInset.bottom, priority: .defaultHigh).activate()

        minimumContentHeightConstraint = NSLayoutConstraint(item: contentView, height: minimumContentHeight, priority: .defaultLow).activate()
    }

    // MARK: Helpers

    private func updateImageSizeIfNeeded() {
        let size = isImageViewHidden ? .zero : imageSize
        imageSizeConstraints.width?.constant = size.width
        imageSizeConstraints.height?.constant = size.height

        roundAvatarViewCornersIfNeeded()
    }

    private func updateTextImageSpacingIfNeeded() {
        let spacing = isImageViewHidden ? 0 : textImageSpacing
        imageAndTitleSpacingConstraint?.constant = spacing
    }

    private func roundAvatarViewCornersIfNeeded() {
        avatarView.layer.cornerRadius = isRoundImageView ? imageSize.height / 2 : 0
    }
}

// MARK: UIAppearance Properties

extension DynamicTableViewCell {
    @objc public dynamic var avatarBorderColor: UIColor? {
        get {
            if let borderColor = avatarView.layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
        set { avatarView.layer.borderColor = newValue?.cgColor }
    }

    @objc public dynamic var avatarBorderWidth: CGFloat {
        get { return avatarView.layer.borderWidth }
        set { avatarView.layer.borderWidth = newValue }
    }

    @objc public dynamic var avatarCornerRadius: CGFloat {
        get { return avatarView.layer.cornerRadius }
        set { avatarView.layer.cornerRadius = newValue }
    }

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
