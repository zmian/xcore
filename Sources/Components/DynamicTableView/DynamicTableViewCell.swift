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
import TZStackView

public class DynamicTableViewCell: BaseTableViewCell {
    public override class var reuseIdentifier: String { return "DynamicTableViewCellIdentifier" }
    private var data: DynamicTableModel!
    private let padding: CGFloat = 15
    private var imageAndTitleSpacingConstraint: NSLayoutConstraint?
    private var imageSizeConstraints: (width: NSLayoutConstraint?,  height: NSLayoutConstraint?)
    private var contentConstraints: (top: NSLayoutConstraint?, left: NSLayoutConstraint?, bottom: NSLayoutConstraint?, right: NSLayoutConstraint?)
    private var labelsStackViewConstraints: (top: NSLayoutConstraint?, bottom: NSLayoutConstraint?)

    /// The distance that the view is inset from the enclosing  content view.
    /// The default value is `UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15)`.
    public dynamic var contentInset = UIEdgeInsets(top: 14, left: 15, bottom: 15, right: 15) {
        didSet {
            contentConstraints.top?.constant    = contentInset.top
            contentConstraints.left?.constant   = contentInset.left
            contentConstraints.bottom?.constant = contentInset.bottom
            contentConstraints.right?.constant  = contentInset.right

            // Update stack view constraints
            labelsStackViewConstraints.top?.constant    = contentInset.top
            labelsStackViewConstraints.bottom?.constant = contentInset.bottom
        }
    }

    /// The default size is `55,55`.
    public dynamic var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            updateImageSizeIfNeeded()
        }
    }

    /// The space between image and text. The default value is `8`.
    public dynamic var textImageSpacing: CGFloat = 8 {
        didSet {
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The space between `title` and `subtitle` labels. The default value is `3`.
    public dynamic var interLabelSpacing: CGFloat {
        get { return labelsStackView.spacing }
        set { labelsStackView.spacing = newValue }
    }

    /// The default value is `false`.
    public dynamic var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            avatarView.hidden = isImageViewHidden
            updateImageSizeIfNeeded()
            updateTextImageSpacingIfNeeded()
        }
    }

    /// The default value is `false`.
    public dynamic var isSubtitleLabelHidden: Bool = false {
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
    public dynamic var isRoundImageView = true {
        didSet {
            avatarView.layer.cornerRadius = isRoundImageView ? imageSize.height / 2 : 0
        }
    }

    /// The background color of the cell when it is highlighted.
    public dynamic var highlightedBackgroundColor: UIColor?
    private var regularBackgroundColor: UIColor?
    private var observeBackgroundColorSetter = true
    public override var backgroundColor: UIColor? {
        didSet {
            if observeBackgroundColorSetter {
                regularBackgroundColor = backgroundColor
            }
        }
    }

    private var onHighlight: ((highlighted: Bool, animated: Bool) -> Void)?
    public func onHighlight(callback: (highlighted: Bool, animated: Bool) -> Void) {
        onHighlight = callback
    }

    private var onSelect: ((selected: Bool, animated: Bool) -> Void)?
    public func onSelect(callback: (selected: Bool, animated: Bool) -> Void) {
        onSelect = callback
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        onSelect?(selected: selected, animated: animated)
    }

    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        if let highlightedBackgroundColor = highlightedBackgroundColor {
            observeBackgroundColorSetter = false
            backgroundColor = highlighted ? highlightedBackgroundColor : regularBackgroundColor
            observeBackgroundColorSetter = true
        }
        onHighlight?(highlighted: highlighted, animated: animated)
    }

    // MARK: UITableViewCellStateMask

    private var willTransitionToState: ((state: UITableViewCellStateMask) -> Void)?
    @nonobjc public func willTransitionToState(callback: (state: UITableViewCellStateMask) -> Void) {
        willTransitionToState = callback
    }
    public override func willTransitionToState(state: UITableViewCellStateMask) {
        super.willTransitionToState(state)
        willTransitionToState?(state: state)
    }

    private var didTransitionToState: ((state: UITableViewCellStateMask) -> Void)?
    @nonobjc public func didTransitionToState(callback: (state: UITableViewCellStateMask) -> Void) {
        didTransitionToState = callback
    }
    public override func didTransitionToState(state: UITableViewCellStateMask) {
        super.didTransitionToState(state)
        didTransitionToState?(state: state)
    }

    // MARK: Subviews

    private let labelsStackView = TZStackView()
    public let avatarView       = UIImageView()
    public let titleLabel       = UILabel()
    public let subtitleLabel    = UILabel()

    // MARK: Setters

    public func setData(data: DynamicTableModel) {
        self.data             = data
        isImageViewHidden     = data.image == nil
        isSubtitleLabelHidden = data.subtitle == nil
        titleLabel.setText(data.title)
        subtitleLabel.setText(data.subtitle)
        avatarView.setImage(data.image)
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// This method is called when `UITableView` invokes `tableView:willDisplayCell:forRowAtIndexPath:` delegate method.
    public func cellWillAppear(indexPath: NSIndexPath, data: DynamicTableModel) {}

    // MARK: Setup Methods

    public override func setupSubviews() {
        clipsToBounds   = true
        backgroundColor = UIColor.clearColor()
        separatorInset  = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
        setupAvatarView()
        setupLabels()
        setupConstraints()
    }

    private func setupAvatarView() {
        contentView.addSubview(avatarView)
        avatarView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        avatarView.contentMode     = .ScaleAspectFill
        avatarView.clipsToBounds   = true

        // Border
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderWidth   = 1
        avatarView.layer.borderColor   = UIColor.blackColor().alpha(0.1).CGColor

        // Ensures smooth scaling quality
        avatarView.layer.minificationFilter = kCAFilterTrilinear
    }

    private func setupLabels() {
        contentView.addSubview(labelsStackView)

        labelsStackView.axis    = .Vertical
        labelsStackView.spacing = 3

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(subtitleLabel)

        // TitleLabel
        titleLabel.font          = UIFont.systemFont(.Body)
        titleLabel.textAlignment = .Left
        titleLabel.textColor     = UIColor.blackColor()
        titleLabel.numberOfLines = 0

        // SubtitleLabel
        subtitleLabel.font          = UIFont.systemFont(.Subheadline)
        subtitleLabel.textAlignment = .Left
        subtitleLabel.textColor     = UIColor.lightGrayColor() // This is ignored if NSAttributedText declares it's own color
        subtitleLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints      = false
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for Labels Stack View
        labelsStackViewConstraints.top    = NSLayoutConstraint(item: labelsStackView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: contentView, constant: contentInset.top).activate()
        labelsStackViewConstraints.bottom = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: labelsStackView, constant: contentInset.bottom).activate()
        NSLayoutConstraint.centerY(labelsStackView).activate()

        // Avatar size
        let size = NSLayoutConstraint.size(avatarView, size: imageSize).activate()
        imageSizeConstraints.width  = size[0]
        imageSizeConstraints.height = size[1]

        // Avatar Center
        NSLayoutConstraint.centerY(avatarView).activate()

        imageAndTitleSpacingConstraint = NSLayoutConstraint(item: labelsStackView, attribute: .Leading, toItem: avatarView, attribute: .Trailing, constant: textImageSpacing).activate()

        // Content Constraints
        contentConstraints.left   = NSLayoutConstraint(item: avatarView, attribute: .Leading, toItem: contentView, constant: contentInset.left).activate()
        contentConstraints.right  = NSLayoutConstraint(item: contentView, attribute: .Trailing, toItem: labelsStackView, constant: contentInset.right).activate()
        contentConstraints.top    = NSLayoutConstraint(item: avatarView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: contentView, constant: contentInset.top, priority: UILayoutPriorityDefaultHigh).activate()
        contentConstraints.bottom = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: avatarView, constant: contentInset.bottom, priority: UILayoutPriorityDefaultHigh).activate()
    }

    // MARK: Helpers

    private func updateImageSizeIfNeeded() {
        let size = isImageViewHidden ? .zero : imageSize
        imageSizeConstraints.width?.constant  = size.width
        imageSizeConstraints.height?.constant = size.height
    }

    private func updateTextImageSpacingIfNeeded() {
        let spacing = isImageViewHidden ? 0 : textImageSpacing
        imageAndTitleSpacingConstraint?.constant = spacing
    }
}

// MARK: UIAppearance Properties

public extension DynamicTableViewCell {
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
