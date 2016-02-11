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

public class DynamicTableViewCell: BaseTableViewCell {
    public override class var reuseIdentifier: String { return "DynamicTableViewCellIdentifier" }
    private var data: DynamicTableModel!
    private let padding: CGFloat      = 15
    private let paddingSmall: CGFloat = 8
    private var imageAndTitleSpacingConstraint: NSLayoutConstraint?
    private var imageSizeConstraints: (width: NSLayoutConstraint?,  height: NSLayoutConstraint?)
    private var contentConstraints: (top: NSLayoutConstraint?, left: NSLayoutConstraint?, bottom: NSLayoutConstraint?, right: NSLayoutConstraint?)

    /// The distance that the view is inset from the enclosing  content view.
    /// The default value is `UIEdgeInsets(top: 7, left: 8, bottom: 8, right: 8)`.
    public var contentInset = UIEdgeInsets.zero {
        didSet {
            contentConstraints.top?.constant    = contentInset.top
            contentConstraints.left?.constant   = contentInset.left
            contentConstraints.bottom?.constant = contentInset.bottom
            contentConstraints.right?.constant  = contentInset.right
        }
    }

    /// The default size is `55,55`.
    public var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            imageSizeConstraints.width?.constant  = imageSize.width
            imageSizeConstraints.height?.constant = imageSize.height
        }
    }

    /// The space between image and text. The default value is `8`.
    public var textImageSpacing: CGFloat = 8 {
        didSet {
            imageAndTitleSpacingConstraint?.constant = textImageSpacing
        }
    }

    /// The default value is `false`.
    public var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            if isImageViewHidden {
                imageSize        = .zero
                textImageSpacing = 0
            } else {
                imageSize        = CGSize(width: 55, height: 55)
                textImageSpacing = paddingSmall
            }
        }
    }

    /// The default value is `true`.
    public var isRoundImageView = true {
        didSet {
            avatarView.layer.cornerRadius = isRoundImageView ? imageSize.height/2 : 0
        }
    }

    /// The background color of the cell when it is highlighted.
    public var highlightedBackgroundColor: UIColor?
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

    // MARK: Subviews

    public let avatarView    = UIImageView()
    public let titleLabel    = UILabel()
    public let subtitleLabel = UILabel()

    // MARK: Setters

    public func setData(data: DynamicTableModel) {
        self.data         = data
        isImageViewHidden = data.image == nil
        titleLabel.setText(data.title)
        subtitleLabel.setText(data.subtitle)
        avatarView.setImage(data.image)
    }

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
        // TitleLabel
        contentView.addSubview(titleLabel)
        titleLabel.font          = UIFont.systemFont(.Body)
        titleLabel.textAlignment = .Left
        titleLabel.textColor     = UIColor.blackColor()
        titleLabel.numberOfLines = 0

        // SubtitleLabel
        contentView.addSubview(subtitleLabel)
        subtitleLabel.font          = UIFont.systemFont(.Subheadline)
        subtitleLabel.textAlignment = .Left
        subtitleLabel.textColor     = UIColor.lightGrayColor() // This is ignored if NSAttributedText declares it's own color
        subtitleLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints    = false
        titleLabel.translatesAutoresizingMaskIntoConstraints    = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for subviews
        let views   = ["avatarView": avatarView, "titleLabel": titleLabel, "subtitleLabel": subtitleLabel, "spacer1": getSpacerView(), "spacer2": getSpacerView()]
        let metrics = ["padding": padding, "interTextPaddingVertical": 1, "paddingMinusOne": padding - 1]
        NSLayoutConstraint.constraintsWithVisualFormat("V:|[spacer1(==spacer2)]-padding-[titleLabel]-interTextPaddingVertical-[subtitleLabel]-paddingMinusOne-[spacer2(==spacer1)]|", options: [.AlignAllLeft, .AlignAllRight], metrics: metrics, views: views).activate()

        // Avatar size
        let size = NSLayoutConstraint.size(avatarView, size: imageSize).activate()
        imageSizeConstraints.width  = size[0]
        imageSizeConstraints.height = size[1]

        // Avatar Center
        NSLayoutConstraint.centerY(avatarView).activate()

        imageAndTitleSpacingConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Leading, toItem: avatarView, attribute: .Trailing, constant: paddingSmall).activate()

        // Content Constraints
        contentConstraints.left   = NSLayoutConstraint(item: avatarView, attribute: .Leading, toItem: contentView, constant: padding).activate()
        contentConstraints.right  = NSLayoutConstraint(item: contentView, attribute: .Trailing, toItem: titleLabel, constant: padding).activate()
        contentConstraints.top    = NSLayoutConstraint(item: avatarView, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: contentView, constant: padding - 1).activate()
        contentConstraints.bottom = NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: avatarView, constant: padding).activate()
    }

    private func getSpacerView() -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(v)
        return v
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
