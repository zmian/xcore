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

    public var verticalIntersectionSpacing: CGFloat = .defaultPadding {
        didSet {
            invalidateLayout()
        }
    }

    public var horizontalMargin: CGFloat = .minimumPadding {
        didSet {
            invalidateLayout()
        }
    }

    public var interColumnSpacing: CGFloat = .defaultPadding {
        didSet {
            invalidateLayout()
        }
    }

    public var cornerRadius: CGFloat = 11 {
        didSet {
            invalidateLayout()
        }
    }

    private static let defaultHeight: CGFloat = 50.0
    private var allSortedAttributes = [Attributes]()
    private var layoutAttributes = [IndexPath: Attributes]()
    private var footerAttributes = [Int: Attributes]()
    private var headerAttributes = [Int: Attributes]()
    private var sectionBackgroundAttributes = [Int: Attributes]()
    private var cachedContentSize: CGSize = .zero

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
        if shouldReloadAttributes {
            layoutAttributes.removeAll()
            footerAttributes.removeAll()
            headerAttributes.removeAll()

            sectionBackgroundAttributes.removeAll()
            shouldReloadAttributes = false
        }

        calculateAttributes()
        calculateBackgroundAttributes()
        prepareZIndex()
    }

    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything || context.invalidateDataSourceCounts {
            shouldReloadAttributes = true
        }

        super.invalidateLayout(with: context)
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.size != collectionView?.bounds.size
    }

    open override func shouldInvalidateLayout(
        forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
        withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes
    )
        -> Bool {
        let hasNewPreferredHeight = preferredAttributes.size.height.rounded() != originalAttributes.size.height.rounded()
        guard hasNewPreferredHeight else { return false }
        var storedAttributes: Attributes?
        switch originalAttributes.representedElementCategory {
            case .cell:
                storedAttributes = layoutAttributes[originalAttributes.indexPath]
            case .supplementaryView:
                switch originalAttributes.representedElementKind {
                    case UICollectionView.elementKindSectionHeader:
                        storedAttributes = headerAttributes[originalAttributes.indexPath.section]
                    case UICollectionView.elementKindSectionFooter:
                        storedAttributes = footerAttributes[originalAttributes.indexPath.section]
                    default:
                        break
                }
            default:
                break
        }
        storedAttributes?.isAutosizeEnabled = false
        storedAttributes?.size = preferredAttributes.size
        return true
    }

    private func calculateAttributes() {
        guard let collectionView = self.collectionView else { return }
        let contentWidth: CGFloat = collectionView.bounds.width - horizontalMargin * 2.0
        let columnWidth = contentWidth - (interColumnSpacing * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
        var columnYOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        allSortedAttributes.removeAll()
        minSection.removeAll()
        maxSection.removeAll()

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            guard itemCount > 0 else { continue }

            let currentColumn = isTileEnabled(forSectionAt: section) ? minColumnIndex(columnYOffset) : maxColumnIndex(columnYOffset)
            let itemWidth = isTileEnabled(forSectionAt: section) ? columnWidth : contentWidth
            var offset = CGPoint(x: itemWidth * CGFloat(currentColumn) + horizontalMargin, y: columnYOffset[currentColumn])

            let sectionVerticalSpacing = offset.y > 0 ? verticalSpacing(betweenSectionAt: section - 1, and: section) : 0

            let headerInfo = headerAttributes(in: section, width: itemWidth)
            let footerInfo = footerAttributes(in: section, width: itemWidth)

            offset.y += sectionVerticalSpacing

            if headerInfo.enabled {
                let headerIndex = IndexPath(item: 0, section: section)
                let attributes = headerAttributes[section] ?? Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndex).apply {
                    $0.size = CGSize(width: itemWidth, height: headerInfo.height ?? XCCollectionViewTileLayout.defaultHeight)
                    $0.corners = (.top, cornerRadius)
                    $0.isAutosizeEnabled = headerInfo.height == nil
                }
                attributes.apply {
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                }

                headerAttributes[section] = attributes
                allSortedAttributes.append(attributes)
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += attributes.size.height
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)

                let attributes = layoutAttributes[indexPath] ?? Attributes(forCellWith: indexPath).apply {
                    $0.size = CGSize(width: itemWidth, height: XCCollectionViewTileLayout.defaultHeight)
                    $0.isAutosizeEnabled = true
                    var corners: UIRectCorner = .none
                    if !headerInfo.enabled, item == 0 {
                        corners.formUnion(.top)
                    }
                    if !footerInfo.enabled, item == itemCount - 1 {
                        corners.formUnion(.bottom)
                    }
                    $0.corners = (corners, cornerRadius)
                }
                // Adjusts the location (if it resized)
                attributes.apply {
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                }
                layoutAttributes[indexPath] = attributes
                allSortedAttributes.append(attributes)
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += attributes.size.height
            }

            if footerInfo.enabled {
                let footerIndex = IndexPath(item: 0, section: section)
                let attributes = footerAttributes[section] ?? Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndex).apply {
                    $0.size = CGSize(width: itemWidth, height: footerInfo.height ?? XCCollectionViewTileLayout.defaultHeight)
                    $0.corners = (.bottom, cornerRadius)
                    $0.isAutosizeEnabled = footerInfo.height == nil
                }
                attributes.apply {
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                }
                footerAttributes[section] = attributes
                allSortedAttributes.append(attributes)
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += attributes.size.height
            }

            columnYOffset[currentColumn] = offset.y
        }

        let maxColumnIndex = self.maxColumnIndex(columnYOffset)
        cachedContentSize = CGSize(width: collectionView.frame.width, height: columnYOffset[maxColumnIndex])
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

    private func calculateBackgroundAttributes() {
        guard let collectionView = self.collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            guard
                isTileEnabled(forSectionAt: section),
                let minAttribute = minSection[section],
                let maxAttribute = maxSection[section]
            else {
                continue
            }

            let backgroundRect = CGRect(origin: minAttribute, size: CGSize(width: maxAttribute.x - minAttribute.x, height: maxAttribute.y - minAttribute.y))

            guard backgroundRect.size.width > 0, backgroundRect.size.height > 0 else { continue }

            let attributes = sectionBackgroundAttributes[section] ?? Attributes(
                forDecorationViewOfKind: UICollectionElementKindSectionBackground,
                with: IndexPath(item: 0, section: section)
            ).apply {
                $0.corners = (.allCorners, cornerRadius)
            }
            attributes.apply {
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

    private func yAxisIntersection(element1: CGRect, element2: CGRect) -> ComparisonResult {
        if element1.maxY >= element2.minY, element2.maxY >= element1.minY {
            return .orderedSame
        }
        if element1.minY < element2.minY {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elementsInRect = [Attributes]()
        var sectionIndexes = Set<Int>()
        guard let closestCandidateIndex = allSortedAttributes.binarySearch(target: rect, transform: { $0.frame }, yAxisIntersection) else {
            return elementsInRect
        }
        for attributes in allSortedAttributes[..<closestCandidateIndex].reversed() {
            guard yAxisIntersection(element1: rect, element2: attributes.frame) == .orderedSame else { break }
            elementsInRect.append(attributes)
            sectionIndexes.insert(attributes.indexPath.section)
        }

        for attributes in allSortedAttributes[closestCandidateIndex...] {
            guard yAxisIntersection(element1: rect, element2: attributes.frame) == .orderedSame else { break }
            elementsInRect.append(attributes)
            sectionIndexes.insert(attributes.indexPath.section)
        }
        elementsInRect.append(contentsOf: sectionIndexes.compactMap({ sectionBackgroundAttributes[$0] }))
        return elementsInRect
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }

    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item == 0 else { return nil }
        switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return headerAttributes[indexPath.section]
            case UICollectionView.elementKindSectionFooter:
                return footerAttributes[indexPath.section]
            default:
                return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }

    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.item == 0 else { return nil }
        switch elementKind {
            case UICollectionElementKindSectionBackground:
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

    private func height(forItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView(collectionView, layout: self, heightForItemAt: indexPath, width: width) ?? 0
    }

    private func headerAttributes(in section: Int, width: CGFloat) -> (enabled: Bool, height: CGFloat?) {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return (false, nil) }
        return delegate.collectionView(collectionView, layout: self, headerAttributesInSection: section, width: width)
    }

    private func footerAttributes(in section: Int, width: CGFloat) -> (enabled: Bool, height: CGFloat?) {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return (false, nil) }
        return delegate.collectionView(collectionView, layout: self, footerAttributesInSection: section, width: width)
    }

    private func verticalSpacing(betweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        guard section != nextSection else { return 0 }
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView(collectionView, layout: self, verticalSpacingBetweenSectionAt: section, and: nextSection)
    }

    private func isTileEnabled(forSectionAt section: Int) -> Bool {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return true }
        return delegate.collectionView(collectionView, layout: self, isTileEnabledInSection: section)
    }
}
