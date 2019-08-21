//
// Picker+RowView.swift
//
// Copyright © 2019 Xcore
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

// MARK: - RowModel

extension Picker {
    public struct RowModel {
        public var image: ImageRepresentable?
        public var title: StringRepresentable
        public var subtitle: StringRepresentable?

        public init(
            image: ImageRepresentable? = nil,
            title: StringRepresentable,
            subtitle: StringRepresentable? = nil
        ) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
        }
    }
}

// MARK: - RowView

extension Picker {
    final public class RowView: UIView, Configurable {
        static let height: CGFloat = 50

        private let titleLabel = UILabel().apply {
            $0.font = .app(style: .body)
            $0.textAlignment = .center
        }

        private let subtitleLabel = UILabel().apply {
            $0.font = .app(style: .caption1)
            $0.textAlignment = .center
        }

        private let imageView = UIImageView().apply {
            $0.isContentModeAutomaticallyAdjusted = true
            $0.enableSmoothScaling()
            $0.anchor.make {
                $0.size.equalTo(CGFloat(30))
            }
        }

        private lazy var stackView = UIStackView(arrangedSubviews: [
            imageView,
            titleStackView
        ]).apply {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = .minimumPadding
        }

        private lazy var titleStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel
        ]).apply {
            $0.axis = .vertical
        }

        override init(frame: CGRect) {
            super.init(
                frame: CGRect(
                    x: 0,
                    y: 0,
                    width: UIScreen.main.bounds.size.width,
                    height: Picker.RowView.height
                )
            )
            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }

        private func commonInit() {
            addSubview(stackView)

            stackView.anchor.make {
                $0.height.greaterThanOrEqualTo(RowView.height)
                $0.width.lessThanOrEqualToSuperview().inset(CGFloat.defaultPadding)
                $0.center.equalToSuperview()
            }
        }

        public func configure(_ model: RowModel) {
            titleLabel.apply {
                $0.setText(model.title)
                $0.sizeToFit()
            }

            subtitleLabel.apply {
                $0.setText(model.subtitle)
                $0.sizeToFit()
                $0.isHidden = model.subtitle == nil
            }

            imageView.apply {
                $0.setImage(model.image)
                $0.isHidden = model.image == nil
            }
        }

        // MARK: - UIAppearance Properties

        @objc public dynamic var titleTextColor: UIColor {
            get { return titleLabel.textColor }
            set { titleLabel.textColor = newValue }
        }

        @objc public dynamic var subtitleTextColor: UIColor {
            get { return subtitleLabel.textColor }
            set { subtitleLabel.textColor = newValue }
        }
    }
}
