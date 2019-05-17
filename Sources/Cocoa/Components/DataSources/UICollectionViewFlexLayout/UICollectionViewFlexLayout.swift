//
//  UICollectionViewFlexLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 16/05/2019.
//  Copyright © 2019 Clarity Money. All rights reserved.
//

import UIKit

private let UICollectionElementKindSectionBackground = "UICollectionElementKindSectionBackground"
private let UICollectionElementKindItemBackground = "UICollectionElementKindItemBackground"

private extension UICollectionViewFlexLayout {
    enum TileStyle: Equatable {
        case both
        case top
        case bottom
        case none

        var corners: UIRectCorner {
            switch self {
            case .both:
                return .allCorners
            case .top:
                return [.topLeft, .topRight]
            case .bottom:
                return [.bottomLeft, .bottomRight]
            case .none:
                return []
            }
        }
    }
}

open class UICollectionViewFlexLayout: UICollectionViewLayout {
    private typealias Attributes = UICollectionViewFlexLayoutAttributes
    private var layoutAttributes: [IndexPath: Attributes] = [:]
    private var sectionBackgroundAttributes: [Int: Attributes] = [:]
    private var cachedContentSize: CGSize = .zero

    private var minYSectionAttribute: [Int: Attributes] = [:]
    private var maxYSectionAttribute: [Int: Attributes] = [:]

    private(set) var minimumItemZIndex: Int = 0

    override open class var layoutAttributesClass: AnyClass {
        return Attributes.self
    }

    override open func prepare() {
        prepareItemAttributes()
        prepareSectionAttributes()
        prepareZIndex()
    }

    override init() {
        super.init()
        register(UICollectionViewFlexBackgroundView.self, forDecorationViewOfKind: UICollectionElementKindSectionBackground)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareItemAttributes() {
        guard let collectionView = self.collectionView else { return }
        let contentWidth = collectionView.frame.width
        var offset: CGPoint = .zero

        layoutAttributes.removeAll()
        minYSectionAttribute.removeAll()
        maxYSectionAttribute.removeAll()

        for section in 0..<collectionView.numberOfSections {
            let sectionVerticalSpacing = section > 0 ? verticalSpacing(betweenSectionAt: section - 1, and: section) : 0

            let sectionMargin = self.margin(forSectionAt: section)
            let sectionPadding = self.padding(forSectionAt: section)

            // maximum value of (height + padding bottom + margin bottom) in current row
            var maxItemBottom: CGFloat = 0

            offset.x = sectionMargin.left + sectionPadding.left // start from left

            let itemCount = collectionView.numberOfItems(inSection: section)

            if itemCount > 0 {
                offset.y += sectionVerticalSpacing + sectionMargin.top + sectionPadding.top // accumulated
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let itemMargin = self.margin(forItemAt: indexPath)
                let itemPadding = self.padding(forItemAt: indexPath)
                let itemSize = self.size(forItemAt: indexPath)

                if item > 0 {
                    offset.x += self.horizontalSpacing(betweenItemAt: IndexPath(item: item - 1, section: section), and: indexPath)
                }

                if offset.x + itemMargin.left + itemPadding.left + itemSize.width + itemPadding.right + itemMargin.right + sectionPadding.right + sectionMargin.right > contentWidth {
                    offset.x = sectionMargin.left + sectionPadding.left // start from left
                    offset.y += maxItemBottom // next line
                    if item > 0 {
                        offset.y += self.verticalSpacing(betweenItemAt: IndexPath(item: item - 1, section: section), and: indexPath)
                    }
                    maxItemBottom = 0
                }

                let attributes = Attributes(forCellWith: indexPath).apply {
                    $0.size = itemSize
                    $0.frame.origin.x = offset.x + itemMargin.left + itemPadding.left
                    $0.frame.origin.y = offset.y + itemMargin.top + itemPadding.top
                    $0.zIndex = zIndex(forItemAt: indexPath)

                    if itemCount == 1 {
                        $0.corners = TileStyle.both.corners
                    } else if item == 0 {
                        $0.corners = TileStyle.top.corners
                    } else if item == itemCount - 1 {
                        $0.corners = TileStyle.bottom.corners
                    } else {
                        $0.corners = TileStyle.none.corners
                    }
                }

                offset.x += itemMargin.left + itemPadding.left + itemSize.width + itemPadding.right + itemMargin.right
                maxItemBottom = max(maxItemBottom, itemMargin.top + itemPadding.top + itemSize.height + itemPadding.bottom + itemMargin.bottom)
                layoutAttributes[indexPath] = attributes

                if self.minYSectionAttribute[section]?.frame.minY ?? .greatestFiniteMagnitude > attributes.frame.minY {
                    self.minYSectionAttribute[section] = attributes
                }

                if self.maxYSectionAttribute[section]?.frame.maxY ?? -.greatestFiniteMagnitude < attributes.frame.maxY {
                    self.maxYSectionAttribute[section] = attributes
                }

                if self.minimumItemZIndex > attributes.zIndex {
                    self.minimumItemZIndex = attributes.zIndex
                }
            }

            if itemCount > 0 {
                offset.y += maxItemBottom + sectionPadding.bottom + sectionMargin.bottom
            }

            cachedContentSize = CGSize(width: contentWidth, height: offset.y)
        }
    }

    private func prepareSectionAttributes() {
        guard let collectionView = self.collectionView else { return }
        sectionBackgroundAttributes.removeAll()
        for section in 0..<collectionView.numberOfSections {
            guard let minYAttribute = self.minYSectionAttribute[section] else { continue }
            guard let maxYAttribute = self.maxYSectionAttribute[section] else { continue }
            let minY = minYAttribute.frame.minY
            let maxY = maxYAttribute.frame.maxY
            let sectionMargin = self.margin(forSectionAt: section)
            let width = collectionView.frame.width - sectionMargin.left - sectionMargin.right
            let height = maxY - minY
            guard width > 0 && height > 0 else { continue }

            let sectionPadding = self.padding(forSectionAt: section)
            let attributes = Attributes(
                forDecorationViewOfKind: UICollectionElementKindSectionBackground,
                with: IndexPath(item: 0, section: section)
            )

            let itemMarginTop = self.margin(forItemAt: minYAttribute.indexPath).top
            let itemMarginBottom = self.margin(forItemAt: maxYAttribute.indexPath).bottom

            let itemPaddingTop = self.padding(forItemAt: minYAttribute.indexPath).top
            let itemPaddingBottom = self.padding(forItemAt: maxYAttribute.indexPath).bottom

            attributes.frame = CGRect(
                x: sectionMargin.left,
                y: minY - sectionPadding.top - itemPaddingTop - itemMarginTop,
                width: width,
                height: height + sectionPadding.top + sectionPadding.bottom + itemPaddingTop + itemPaddingBottom + itemMarginTop + itemMarginBottom
            )
            sectionBackgroundAttributes[section] = attributes
        }
    }

    private func prepareZIndex() {
        for attributes in self.sectionBackgroundAttributes.values {
              attributes.zIndex = minimumItemZIndex - 2
        }
    }

    override open var collectionViewContentSize: CGSize {
        return self.cachedContentSize
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.layoutAttributes.values.filter { $0.frame.intersects(rect) }
        + self.sectionBackgroundAttributes.values.filter { $0.frame.intersects(rect) }
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath]
    }

    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }

    override open func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
            case UICollectionElementKindSectionBackground:
                guard indexPath.item == 0 else { return nil }
                return self.sectionBackgroundAttributes[indexPath.section]
            default:
                return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        }
    }

    open func maximumWidth(forItemAt indexPath: IndexPath) -> CGFloat {
        guard let collectionView = self.collectionView else { return 0 }
        let sectionMargin = self.margin(forSectionAt: indexPath.section)
        let sectionPadding = self.padding(forSectionAt: indexPath.section)
        let itemMargin = self.margin(forItemAt: indexPath)
        let itemPadding = self.padding(forItemAt: indexPath)
        return collectionView.frame.width
            - sectionMargin.left
            - sectionPadding.left
            - itemMargin.left
            - itemPadding.left
            - itemPadding.right
            - itemMargin.right
            - sectionPadding.right
            - sectionMargin.right
    }
}

extension UICollectionViewFlexLayout {
    var delegate: UICollectionViewDelegateFlexLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlexLayout
    }

    public func size(forItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
    }

    public func verticalSpacing(betweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        guard section != nextSection else { return 0 }
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, verticalSpacingBetweenSectionAt: section, and: nextSection) ?? 0
    }

    public func margin(forSectionAt section: Int) -> UIEdgeInsets {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, marginForSectionAt: section) ?? .zero
    }

    public func padding(forSectionAt section: Int) -> UIEdgeInsets {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, paddingForSectionAt: section) ?? .zero
    }

    public func horizontalSpacing(betweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        guard indexPath != nextIndexPath else { return 0 }
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, horizontalSpacingBetweenItemAt: indexPath, and: nextIndexPath) ?? 0
    }

    public func verticalSpacing(betweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        guard indexPath != nextIndexPath else { return 0 }
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, verticalSpacingBetweenItemAt: indexPath, and: nextIndexPath) ?? 0
    }

    public func margin(forItemAt indexPath: IndexPath) -> UIEdgeInsets {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, marginForItemAt: indexPath) ?? .zero
    }

    public func padding(forItemAt indexPath: IndexPath) -> UIEdgeInsets {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, paddingForItemAt: indexPath) ?? .zero
    }

    public func zIndex(forItemAt indexPath: IndexPath) -> Int {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, zIndexForItemAt: indexPath) ?? 0
    }
}
