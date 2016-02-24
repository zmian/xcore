//
// IconLabelCollectionViewCell.swift
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

public class IconLabelCollectionViewCell: UICollectionViewCell {
    public class var reuseIdentifier: String { return "IconLabelCollectionViewCellIdentifier" }
    public let iconLabelView = IconLabelView()
    let deleteButton = UIButton()

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

    public func setData(data: ImageTitleDisplayable) {
        iconLabelView.setData(data)
    }

    // MARK: Setup Method

    private func setupSubviews() {
        contentView.addSubview(iconLabelView)
        NSLayoutConstraint.constraintsForViewToFillSuperview(iconLabelView).activate()
        iconLabelView.userInteractionEnabled   = false
        iconLabelView.isRoundImageView         = true
        iconLabelView.imagePadding             = 0
        iconLabelView.imageBackgroundColor     = UIColor.blackColor().alpha(0.1)
        iconLabelView.imageView.borderColor    = UIColor.blackColor().alpha(0.1)
        iconLabelView.titleLabel.numberOfLines = 1
        iconLabelView.titleLabel.textColor     = UIColor.lightGrayColor()
        iconLabelView.subtitleLabel.textColor  = UIColor.lightGrayColor()

        setupDeleteButton()
    }

    // MARK: Delete Button

    private func setupDeleteButton() {
        let buttonSize: CGFloat = 44
        let offset = iconLabelView.isRoundImageView ? buttonSize / 4 : buttonSize / 2
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.size(deleteButton, size: CGSize(width: buttonSize, height: buttonSize)).activate()
        NSLayoutConstraint(item: deleteButton, attribute: .Top, toItem: contentView, constant: -offset).activate()
        NSLayoutConstraint(item: contentView, attribute: .Trailing, toItem: deleteButton, constant: -offset).activate()

        deleteButton.image = UIImage(assetIdentifier: .CollectionViewCellDeleteIcon)


        deleteButton.imageView?.cornerRadius    = 24/2
        deleteButton.imageView?.backgroundColor = UIColor.whiteColor()

        deleteButton.layer.shadowColor       = UIColor.blackColor().CGColor
        deleteButton.layer.shadowOffset      = .zero
        deleteButton.layer.shadowOpacity     = 0.3
        deleteButton.layer.shadowRadius      = 5

        deleteButton.hidden = true
    }

    func setDeleteButtonHidden(hide: Bool) {
        guard hide != deleteButton.hidden else { return }

        if hide {
            deleteButtonZoomOut()
        } else {
            deleteButtonZoomIn()
        }
    }

    private func deleteButtonZoomIn() {
        deleteButton.hidden    = false
        deleteButton.alpha     = 0
        deleteButton.transform = CGAffineTransformMakeScale(0.3, 0.3)
        UIView.animateWithDuration(0.2, animations: {
            self.deleteButton.alpha     = 1
            self.deleteButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }, completion: { _ in
            UIView.animateWithDuration(0.2) {
                self.deleteButton.transform = CGAffineTransformIdentity
            }
        })
    }

    private func deleteButtonZoomOut() {
        UIView.animateWithDuration(0.2, animations: {
            self.deleteButton.alpha     = 0
            self.deleteButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }, completion: { _ in
            self.deleteButton.hidden = true
        })
    }
}
