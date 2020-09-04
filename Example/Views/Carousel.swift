//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct Carousel: View {
    public enum Style {
        case `default`
        case infiniteScroll
        case multipleItemsPerPage
    }

    public struct Item: CarouselAccessibilitySupport {
        let title: String
        let image: ImageRepresentable

        public func accessibilityItem(index: Int) -> CarouselAccessibilityItem? {
            nil
        }
    }

    /// The specific carousel style (e.g., infinite scroll or multiple items per
    /// page).
    ///
    /// The default value is `.default`.
    public let style: Style

    /// A boolean value indicating whether auto scrolling behavior is enabled.
    ///
    /// The default value is `false`.
    public let isAutoScrollingEnabled: Bool

    public let isAutoScrolling: Bool

    public let items: [Item]

    init(
        style: Carousel.Style = .default,
        isAutoScrollingEnabled: Bool = false,
        isAutoScrolling: Bool = false,
        items: [Carousel.Item]
    ) {
        self.isAutoScrollingEnabled = isAutoScrollingEnabled
        self.isAutoScrolling = isAutoScrolling
        self.items = items
        self.style = style
    }

    public var body: some View {
        CarouselViewUIKit(
            style: style,
            isAutoScrollingEnabled: isAutoScrollingEnabled,
            isAutoScrolling: isAutoScrolling,
            items: items
        )
    }
}

private struct CarouselViewUIKit: UIViewRepresentable {
    fileprivate typealias Content = CarouselView<ItemCell>

    /// The specific carousel style (e.g., infinite scroll or multiple items per
    /// page).
    ///
    /// The default value is `.default`.
    private let style: Content.Style

    /// A boolean value indicating whether auto scrolling behavior is enabled.
    ///
    /// The default value is `false`.
    private var isAutoScrollingEnabled: Bool

    private var isAutoScrolling: Bool

    private let items: [Carousel.Item]

    fileprivate init(
        style: Carousel.Style,
        isAutoScrollingEnabled: Bool,
        isAutoScrolling: Bool,
        items: [Carousel.Item]
    ) {
        self.isAutoScrollingEnabled = isAutoScrollingEnabled
        self.isAutoScrolling = isAutoScrolling
        self.items = items

        switch style {
            case .default:
                self.style = .default
            case .infiniteScroll:
                self.style = .infiniteScroll
            case .multipleItemsPerPage:
                self.style = .multipleItemsPerPage
        }
    }

    fileprivate func makeUIView(context: Context) -> Content {
        Content().apply {
            $0.style = style
            $0.startAutoScrolling()
            $0.pageControl.apply {
                $0.dotsPadding = .maximumPadding
                $0.pageIndicatorTintColor = UIColor.black.alpha(0.3)
                $0.currentPageIndicatorTintColor = .black
            }
        }
    }

    fileprivate func updateUIView(_ uiView: Content, context: Context) {
        uiView.apply {
            $0.style = style
            $0.configure(items: items)
            isAutoScrolling ? $0.startAutoScrolling() : $0.stopAutoScrolling()
        }
    }
}

// MARK: - ItemCell

extension CarouselViewUIKit {
    fileprivate final class ItemCell: XCCollectionViewCell, CarouselViewCellRepresentable {
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

        func configure(_ model: Carousel.Item) {
            titleLabel.text = model.title
            iconView.setImage(model.image)
        }
    }
}
