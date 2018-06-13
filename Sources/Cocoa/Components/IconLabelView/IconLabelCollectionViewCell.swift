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

open class IconLabelCollectionViewCell: XCCollectionViewCell {
    open let iconLabelView = IconLabelView()
    let deleteButton = UIButton()

    // MARK: Setters

    open func setData(_ data: ImageTitleDisplayable) {
        iconLabelView.setData(data)
    }

    // MARK: Setup Method

    open override func commonInit() {
        contentView.addSubview(iconLabelView)
        NSLayoutConstraint.constraintsForViewToFillSuperview(iconLabelView).activate()
        iconLabelView.isUserInteractionEnabled = false
        iconLabelView.isRoundImageView         = true
        iconLabelView.imagePadding             = 0
        iconLabelView.imageBackgroundColor     = UIColor.black.alpha(0.1)
        iconLabelView.imageView.borderColor    = UIColor.black.alpha(0.1)
        iconLabelView.titleLabel.numberOfLines = 1
        iconLabelView.titleLabel.textColor     = .lightGray
        iconLabelView.subtitleLabel.textColor  = .lightGray

        setupDeleteButton()
    }

    // MARK: Delete Button

    private func setupDeleteButton() {
        let buttonSize: CGFloat = 44
        let offset = iconLabelView.isRoundImageView ? buttonSize / 4 : buttonSize / 2
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.size(deleteButton, size: CGSize(width: buttonSize, height: buttonSize)).activate()
        NSLayoutConstraint(item: deleteButton, attribute: .top, toItem: contentView, constant: -offset).activate()
        NSLayoutConstraint(item: contentView, attribute: .trailing, toItem: deleteButton, constant: -offset).activate()

        deleteButton.image(R(.collectionViewCellDeleteIcon), in: .xcore, for: .normal)
        deleteButton.imageView?.cornerRadius    = 24/2
        deleteButton.imageView?.backgroundColor = .white

        deleteButton.layer.shadowColor   = UIColor.black.cgColor
        deleteButton.layer.shadowOffset  = .zero
        deleteButton.layer.shadowOpacity = 0.3
        deleteButton.layer.shadowRadius  = 5

        deleteButton.isHidden = true
    }

    func setDeleteButtonHidden(_ hide: Bool, animated: Bool = true) {
        guard hide != deleteButton.isHidden else { return }

        if animated {
            if hide {
                deleteButtonZoomOut()
            } else {
                deleteButtonZoomIn()
            }
        } else {
            deleteButton.isHidden = hide
        }
    }

    private func deleteButtonZoomIn() {
        deleteButton.isHidden    = false
        deleteButton.alpha     = 0
        deleteButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2, animations: {
            self.deleteButton.alpha     = 1
            self.deleteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButton.transform = .identity
            }) 
        })
    }

    private func deleteButtonZoomOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.deleteButton.alpha     = 0
            self.deleteButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            self.deleteButton.isHidden = true
        })
    }
}
