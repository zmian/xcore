//
// XCCollectionViewTileLayout.swift
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

open class XCCollectionViewTileLayout: UICollectionViewLayout {
    private let UICollectionElementKindSectionBackground = "UICollectionElementKindSectionBackground"

    public var numberOfColumns = 1 {
        didSet {
            invalidateLayout()
        }
    }

    private var layoutAttributes: [IndexPath: Attributes] = [:]
    private var footerAttributes: [IndexPath: Attributes] = [:]
    private var headerAttributes: [IndexPath: Attributes] = [:]
    private var sectionBackgroundAttributes: [Int: Attributes] = [:]
    private var cachedContentSize: CGSize = 0

    private var shouldReloadAttributes = true

    private var minSection: [Int: CGPoint] = [:]
    private var maxSection: [Int: CGPoint] = [:]

    private(set) var minimumItemZIndex: Int = 0

    open override class var layoutAttributesClass: AnyClass {
        return Attributes.self
    }

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        register(XCCollectionViewTileBackgroundView.self, forDecorationViewOfKind: UICollectionElementKindSectionBackground)
    }

    open override func prepare() {
        super.prepare()
        guard shouldReloadAttributes else { return }
        shouldReloadAttributes = false

        prepareItemAttributes()
        prepareBackgroundAttributes()
        prepareZIndex()
    }

    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            shouldReloadAttributes = true
        }

        super.invalidateLayout(with: context)
    }

    private func prepareItemAttributes() {
        guard let collectionView = collectionView else { return }
        let contentWidth = collectionView.frame.width
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var columnYOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        layoutAttributes.removeAll()
        footerAttributes.removeAll()
        headerAttributes.removeAll()

        minSection.removeAll()
        maxSection.removeAll()

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            guard itemCount > 0 else { continue }

            let currentColumn = minColumnIndex(columnYOffset)

            let sectionMargin = margin(forSectionAt: section)

            // first column -> full leading margin, other columns -> half leading margin
            // last column -> full trailing margin, other columns -> half trailing margin
            let leftMargin = currentColumn == 0 ? sectionMargin.left : sectionMargin.left / 2
            let rightMargin = currentColumn == numberOfColumns - 1 ? sectionMargin.right : sectionMargin.right / 2

            let availableWidth = columnWidth - leftMargin - rightMargin
            var offset = CGPoint(x: columnWidth * CGFloat(currentColumn) + leftMargin, y: columnYOffset[currentColumn])

            let sectionVerticalSpacing = offset.y > 0 ? verticalSpacing(betweenSectionAt: section - 1, and: section) : 0

            let headerHeight = self.headerHeight(forSectionAt: section, width: availableWidth)
            let footerHeight = self.footerHeight(forSectionAt: section, width: availableWidth)

            offset.y += sectionVerticalSpacing + sectionMargin.top

            if headerHeight > 0 {
                let headerIndex = IndexPath(item: 0, section: section)
                let attributes = Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndex).apply {
                    $0.size = CGSize(width: availableWidth, height: headerHeight)
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                    $0.cornerRadius = cornerRadius(forSectionAt: section)
                    $0.corners = .top
                }
                headerAttributes[headerIndex] = attributes
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += headerHeight
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let itemHeight = height(forItemAt: indexPath, width: availableWidth)
                if item > 0 {
                    offset.y += verticalSpacing(betweenItemAt: IndexPath(item: item - 1, section: section), and: indexPath)
                }

                let attributes = Attributes(forCellWith: indexPath).apply {
                    $0.size = CGSize(width: availableWidth, height: itemHeight)
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                    $0.zIndex = zIndex(forItemAt: indexPath)
                    $0.cornerRadius = cornerRadius(forSectionAt: section)

                    var corners: UIRectCorner = .none
                    if item == 0 && headerHeight == 0 {
                        corners.formUnion(.top)
                    }
                    if item == itemCount - 1 && footerHeight == 0 {
                        corners.formUnion(.bottom)
                    }
                    $0.corners = corners
                }
                layoutAttributes[indexPath] = attributes
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += attributes.size.height
            }

            if footerHeight > 0 {
                let footerIndex = IndexPath(item: 0, section: section)
                let attributes = Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndex).apply {
                    $0.size = CGSize(width: availableWidth, height: footerHeight)
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                    $0.cornerRadius = cornerRadius(forSectionAt: section)
                    $0.corners = .bottom
                }

                footerAttributes[footerIndex] = attributes
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += footerHeight
            }

            offset.y += sectionMargin.bottom
            columnYOffset[currentColumn] = offset.y
        }

        let maxColumnIndex = self.maxColumnIndex(columnYOffset)
        cachedContentSize = CGSize(width: contentWidth, height: columnYOffset[maxColumnIndex])
    }

    private func calculateMinMaxAttributes(with attributes: Attributes, in section: Int) {
        var minimum: CGPoint = minSection[section] ?? CGPoint(x: CGFloat.greatestFiniteMagnitude, y: CGFloat.greatestFiniteMagnitude)
        var maximum: CGPoint = maxSection[section] ?? CGPoint(x: 0.0, y: 0.0)

        if attributes.frame.minX < minimum.x { minimum.x = attributes.frame.minX }
        if attributes.frame.minY < minimum.y { minimum.y = attributes.frame.minY }
        if attributes.frame.maxX > maximum.x { maximum.x = attributes.frame.maxX }
        if attributes.frame.maxY > maximum.y { maximum.y = attributes.frame.maxY }

        minSection[section] = minimum
        maxSection[section] = maximum

        if minimumItemZIndex > attributes.zIndex {
            minimumItemZIndex = attributes.zIndex
        }
    }

    private func prepareBackgroundAttributes() {
        guard let collectionView = collectionView else { return }
        sectionBackgroundAttributes.removeAll()
        for section in 0..<collectionView.numberOfSections {
            guard
                shadowEnabled(forSectionAt: section),
                let minAttribute = minSection[section],
                let maxAttribute = maxSection[section]
            else {
                continue
            }

            let backgroundRect = CGRect(origin: minAttribute, size: CGSize(width: maxAttribute.x - minAttribute.x, height: maxAttribute.y - minAttribute.y))

            guard backgroundRect.size.width > 0, backgroundRect.size.height > 0 else { continue }

            let attributes = Attributes(
                forDecorationViewOfKind: UICollectionElementKindSectionBackground,
                with: IndexPath(item: 0, section: section)
            ).apply {
                $0.cornerRadius = cornerRadius(forSectionAt: section)
                $0.corners = .allCorners
                $0.frame = backgroundRect
            }

            sectionBackgroundAttributes[section] = attributes
        }
    }

    private func prepareZIndex() {
        for attributes in sectionBackgroundAttributes.values {
            attributes.zIndex = minimumItemZIndex - 2
        }
    }

    open override var collectionViewContentSize: CGSize {
        return cachedContentSize
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.values.filter { $0.frame.intersects(rect) }
            + sectionBackgroundAttributes.values.filter { $0.frame.intersects(rect) }
            + footerAttributes.values.filter { $0.frame.intersects(rect) }
            + headerAttributes.values.filter { $0.frame.intersects(rect) }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }

    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return headerAttributes[indexPath]
            case UICollectionView.elementKindSectionFooter:
                return footerAttributes[indexPath]
            default:
                return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }

    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
            case UICollectionElementKindSectionBackground:
                guard indexPath.item == 0 else { return nil }
                return sectionBackgroundAttributes[indexPath.section]
            default:
                return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
        }
    }
}

extension XCCollectionViewTileLayout {
    private func minColumnIndex(_ columns: [CGFloat]) -> Int {
        var index = 0
        var minYOffset = CGFloat.infinity
        for (i, columnOffset) in columns.enumerated() where columnOffset < minYOffset {
            minYOffset = columnOffset
            index = i
        }
        return index
    }

    private func maxColumnIndex(_ columns: [CGFloat]) -> Int {
        var index = 0
        var maxYOffset: CGFloat = -1.0
        for (i, columnOffset) in columns.enumerated() where columnOffset > maxYOffset {
            maxYOffset = columnOffset
            index = i
        }
        return index
    }
}

extension XCCollectionViewTileLayout {
    var delegate: XCCollectionViewDelegateTileLayout? {
        return collectionView?.delegate as? XCCollectionViewDelegateTileLayout
    }

    private func height(forItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, heightForItemAt: indexPath, width: width) ?? 0
    }

    private func verticalSpacing(betweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        guard section != nextSection else { return 0 }
        guard let collectionView = collectionView, let delegate = delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, verticalSpacingBetweenSectionAt: section, and: nextSection) ?? 0
    }

    private func margin(forSectionAt section: Int) -> UIEdgeInsets {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, marginForSectionAt: section) ?? 0
    }

    private func verticalSpacing(betweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        guard indexPath != nextIndexPath else { return 0 }
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, verticalSpacingBetweenItemAt: indexPath, and: nextIndexPath) ?? 0
    }

    private func zIndex(forItemAt indexPath: IndexPath) -> Int {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, zIndexForItemAt: indexPath) ?? 0
    }

    private func headerHeight(forSectionAt section: Int, width: CGFloat) -> CGFloat {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, heightForHeaderInSection: section, width: width) ?? 0
    }

    private func footerHeight(forSectionAt section: Int, width: CGFloat) -> CGFloat {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, heightForFooterInSection: section, width: width) ?? 0
    }

    private func cornerRadius(forSectionAt section: Int) -> CGFloat {
        guard let collectionView = collectionView, let delegate = delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, cornerRadiusAt: section) ?? 0
    }

    private func shadowEnabled(forSectionAt section: Int) -> Bool {
        guard let collectionView = collectionView, let delegate = delegate else { return false }
        return delegate.collectionView?(collectionView, layout: self, shadowEnabledAt: section) ?? false
    }
}
