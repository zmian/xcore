//
//  CarouselViewController.swift
//  Example
//
//  Created by Guillermo Waitzel on 30/09/2019.
//  Copyright © 2019 Xcore. All rights reserved.
//

import UIKit
import Xcore

extension CarouselViewController {
    struct Item: CarouselAccessibilitySupport {
        let title: String
        let image: ImageRepresentable

        func accessibilityItem(index: Int) -> CarouselAccessibilityItem? {
            return nil
        }
    }
}

final class CarouselViewController: UIViewController {
    let items = [
        Item(title: "First Item", image: r(.blueJay)),
        Item(title: "Second Item", image: r(.blueJay)),
        Item(title: "Third Item", image: r(.blueJay))
    ]

    let carouselView = CarouselView<ItemCell>().apply {
        $0.style = .infiniteScroll
        $0.pageControl.apply {
            $0.dotsPadding = .maximumPadding
            $0.pageIndicatorTintColor = .black
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

extension CarouselViewController {
    final class ItemCell: XCCollectionViewCell, CarouselViewCellRepresentable {
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
