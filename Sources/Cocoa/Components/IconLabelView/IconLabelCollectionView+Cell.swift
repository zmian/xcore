//
// IconLabelCollectionView+Cell.swift
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

extension IconLabelCollectionView {
    open class Cell: XCCollectionViewCell {
        public let iconLabelView = IconLabelView().apply {
            $0.isUserInteractionEnabled = false
            $0.isImageViewRounded = true
            $0.imagePadding = 0
            $0.imageBackgroundColor = UIColor.black.alpha(0.1)
            $0.imageView.borderColor = UIColor.black.alpha(0.1)
            $0.titleLabel.numberOfLines = 1
            $0.titleLabel.textColor = .lightGray
            $0.subtitleLabel.textColor = .lightGray
        }

        private let deleteButton = UIButton().apply {
            $0.isHidden = true

            $0.image(r(.collectionViewCellDeleteIcon), for: .normal)
            $0.imageView?.cornerRadius = 24/2
            $0.imageView?.backgroundColor = .white

            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = .zero
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowRadius = 5
        }

        // MARK: Setup Method

        open override func commonInit() {
            contentView.addSubview(iconLabelView)
            iconLabelView.anchor.edges.equalToSuperview()
            setupDeleteButton()
        }

        // MARK: Delete Button

        private func setupDeleteButton() {
            contentView.addSubview(deleteButton)
            let buttonSize: CGFloat = 44
            let offset = iconLabelView.isImageViewRounded ? buttonSize / 4 : buttonSize / 2

            deleteButton.anchor.make {
                $0.size.equalTo(buttonSize)
                $0.top.equalToSuperview().inset(-offset)
                $0.trailing.equalToSuperview().inset(-offset)
            }
        }
    }
}

extension IconLabelCollectionView.Cell {
    open func configure(_ data: ImageTitleDisplayable, at indexPath: IndexPath, collectionView: IconLabelCollectionView) {
        iconLabelView.configure(data)
        setDeleteButtonHidden(!collectionView.isEditing, animated: false)
        deleteButton.addAction(.touchUpInside) { [weak collectionView] sender in
            collectionView?.removeItems([indexPath])
        }
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
        deleteButton.isHidden = false
        deleteButton.alpha = 0
        deleteButton.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)

        UIView.animate(withDuration: 0.2, animations: {
            self.deleteButton.alpha = 1
            self.deleteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.deleteButton.transform = .identity
            }
        })
    }

    private func deleteButtonZoomOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.deleteButton.alpha = 0
            self.deleteButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            self.deleteButton.isHidden = true
        })
    }
}
