//
// CarouselViewController.swift
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

extension CarouselViewController {
    private struct Item: CarouselAccessibilitySupport {
        let title: String
        let image: ImageRepresentable

        func accessibilityItem(index: Int) -> CarouselAccessibilityItem? {
            nil
        }
    }
}

final class CarouselViewController: UIViewController {
    private let items = [
        Item(title: "First Item", image: r(.blueJay)),
        Item(title: "Second Item", image: r(.blueJay)),
        Item(title: "Third Item", image: r(.blueJay))
    ]

    private let carouselView = CarouselView<ItemCell>().apply {
        $0.style = .infiniteScroll
        $0.startAutoScrolling()
        $0.pageControl.apply {
            $0.dotsPadding = .maximumPadding
            $0.pageIndicatorTintColor = UIColor.black.alpha(0.3)
            $0.currentPageIndicatorTintColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carousel Example"
        view.backgroundColor = .white
        view.addSubview(carouselView)
        carouselView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        carouselView.configure(items: items)
    }
}

// MARK: - ItemCell

extension CarouselViewController {
    final private class ItemCell: XCCollectionViewCell, CarouselViewCellRepresentable {
        private let iconView = UIImageView().apply {
            $0.contentMode = .scaleAspectFit
            $0.snp.makeConstraints { make in
                make.height.equalTo(100)
            }
        }

        private lazy var titleLabel = UILabel().apply {
            $0.text = "Default Text"
            $0.font = .app(style: .body)
            $0.textColor = .black
            $0.textAlignment = .center
            $0.resistsSizeChange()
        }

        private lazy var stackView = UIStackView(arrangedSubviews: [
            iconView,
            titleLabel
        ]).apply {
            $0.axis = .vertical
            $0.spacing = .defaultPadding
            titleLabel.snp.makeConstraints { make in
                make.leading.greaterThanOrEqualToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            }
        }

        override func commonInit() {
            super.commonInit()
            contentView.backgroundColor = .lightGray
            contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        func configure(_ model: Item) {
            titleLabel.text = model.title
            iconView.setImage(model.image)
        }
    }
}
