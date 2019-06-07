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
            shouldReloadAttributes = true
            invalidateLayout()
        }
    }

    public var verticalIntersectionSpacing: CGFloat = .defaultPadding {
        didSet {
            shouldReloadAttributes = true
            invalidateLayout()
        }
    }

    public var horizontalMargin: CGFloat = .minimumPadding {
        didSet {
            shouldReloadAttributes = true
            invalidateLayout()
        }
    }

    public var interColumnSpacing: CGFloat = .defaultPadding {
        didSet {
            shouldReloadAttributes = true
            invalidateLayout()
        }
    }

    public var cornerRadius: CGFloat = 11 {
        didSet {
            shouldReloadAttributes = true
            invalidateLayout()
        }
    }

    private static let defaultHeight: CGFloat = 1000
    private var cachedContentSize: CGSize = .zero
    private var shouldReloadAttributes = true
    private var shouldRecalculateSectionPosition = false
    private var minimumItemZIndex: Int = 0

    // Layout Elements
    private var attributesBySection = [Int: [Attributes]]()
    private var layoutAttributes = [IndexPath: Attributes]()
    private var footerAttributes = [Int: Attributes]()
    private var headerAttributes = [Int: Attributes]()
    private var sectionBackgroundAttributes = [Int: Attributes]()
    private var cachedDelegateAttributes = [Int: (Bool, CGFloat)]()
    
    // Elements in rect calculation
    private var sectionRects = [Int: CGRect]()
    private var sectionIndexesByColumn = [[Int]]()
    

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
        guard !shouldReloadAttributes else {
            shouldReloadAttributes = false
            sectionRects.removeAll()

            attributesBySection.removeAll()
            layoutAttributes.removeAll()
            footerAttributes.removeAll()
            headerAttributes.removeAll()
            sectionBackgroundAttributes.removeAll()
            cachedDelegateAttributes.removeAll()

            calculateAttributes()
            calculateBackgroundAttributes()
            return
        }

        guard !shouldRecalculateSectionPosition else {
            shouldRecalculateSectionPosition = false
            calculateAttributes(shouldCreateAttributes: false)
            return
        }
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
        return hasNewPreferredHeight
    }

    open override func invalidationContext(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutInvalidationContext {

        let invalidationContext = super.invalidationContext(forPreferredLayoutAttributes: preferredAttributes, withOriginalAttributes: originalAttributes)
        updateItemHeight(preferredAttributes: preferredAttributes, originalAttributes: originalAttributes, invalidationContext: invalidationContext)
        return invalidationContext
    }

    private func updateItemHeight(preferredAttributes: UICollectionViewLayoutAttributes, originalAttributes: UICollectionViewLayoutAttributes, invalidationContext: UICollectionViewLayoutInvalidationContext) {

        guard let storedAttributes = getStoredAttribute(from: originalAttributes) else { return }
        let heightDifference = preferredAttributes.size.height - storedAttributes.frame.size.height
        storedAttributes.isAutosizeEnabled = false
        storedAttributes.frame.size = preferredAttributes.size

        let targetSection = originalAttributes.indexPath.section
        for attributes in attributesBySection[targetSection]! {
            if attributes.offsetInSection > storedAttributes.offsetInSection {
                attributes.offsetInSection += heightDifference
            }
        }
        sectionRects[targetSection]?.size.height += heightDifference
        shouldRecalculateSectionPosition = true
    }

    private func calculateAttributes(shouldCreateAttributes: Bool = true) {
        guard let collectionView = self.collectionView else { return }
        let contentWidth: CGFloat = collectionView.bounds.width - horizontalMargin * 2.0
        let columnWidth = (contentWidth - (interColumnSpacing * CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)
        var columnYOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var offset: CGPoint = .zero
        var itemCount: Int = 0
        var tileEnabled: Bool = false
        var currentColumn: Int = 0
        var itemWidth: CGFloat = 0
        var margin: CGFloat = 0
        var verticalSpacing: CGFloat = 0
        var cachedParameters: (isTileEnabled: Bool, verticalSpacing: CGFloat)?

        sectionIndexesByColumn.removeAll()
        for _ in 0..<numberOfColumns {
            sectionIndexesByColumn.append([Int]())
        }

        for section in 0..<collectionView.numberOfSections {
            cachedParameters = cachedDelegateAttributes[section]
            itemCount = collectionView.numberOfItems(inSection: section)
            tileEnabled =  cachedParameters?.isTileEnabled ?? self.isTileEnabled(forSectionAt: section)
            currentColumn = tileEnabled ? minColumn(columnYOffset).index : maxColumn(columnYOffset).index
            itemWidth = tileEnabled ? columnWidth : collectionView.frame.size.width
            margin = tileEnabled ? horizontalMargin : 0
            verticalSpacing = cachedParameters?.verticalSpacing ?? self.verticalSpacing(betweenSectionAt: section - 1, and: section)

            // Add section to column
            sectionIndexesByColumn[currentColumn].append(section)
            if cachedParameters == nil {
                cachedDelegateAttributes[section] = (tileEnabled, verticalSpacing)
            }

            offset.x = tileEnabled ? (itemWidth + interColumnSpacing) * CGFloat(currentColumn) + margin : 0
            offset.y = columnYOffset[currentColumn]

            // Add vertical spacing
            offset.y += offset.y > 0 ? verticalSpacing : 0

            // Create item attributes
            if shouldCreateAttributes {
                // Create section rect
                sectionRects[section] = CGRect(origin: offset, size: CGSize(width: itemWidth, height: 0))
                // Update height of section rect
                sectionRects[section]?.size.height = createAttributes(for: section, itemWidth: itemWidth, itemCount: itemCount)
            } else {
                sectionRects[section]!.origin = offset
            }

            offset.y += sectionRects[section]!.height
            if tileEnabled {
                columnYOffset[currentColumn] = offset.y
            } else{
                for i in 0..<columnYOffset.count {
                    columnYOffset[i] = offset.y
                }
            }
        }

        cachedContentSize.height = self.maxColumn(self.columnsHeight).height
    }

    private func createAttributes(for section: Int, itemWidth: CGFloat, itemCount: Int) -> CGFloat {
        var offsetInSection: CGFloat = 0
        attributesBySection[section] = [Attributes]()

        guard itemCount > 0 else {
            return 0
        }

        let headerInfo = headerAttributes(in: section, width: itemWidth)
        let footerInfo = footerAttributes(in: section, width: itemWidth)
        
        if headerInfo.enabled {
            let headerIndex = IndexPath(item: 0, section: section)
            let attributes = headerAttributes[section] ?? Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndex).apply {
                $0.size = CGSize(width: itemWidth, height: headerInfo.height ?? XCCollectionViewTileLayout.defaultHeight)
                $0.corners = isTileEnabled(forSectionAt: section) ? (.top, cornerRadius) : (.none, 0)
                $0.isAutosizeEnabled = headerInfo.height == nil
                $0.offsetInSection = offsetInSection
            }
            
            headerAttributes[section] = attributes
            offsetInSection += attributes.size.height
            attributesBySection[section]?.append(attributes)
        }
        
        var indexPath = IndexPath(item: 0, section: section)
        for item in 0..<itemCount {
            indexPath.item = item
            let attributes = layoutAttributes[indexPath] ?? Attributes(forCellWith: indexPath).apply {
                $0.size = CGSize(width: itemWidth, height: XCCollectionViewTileLayout.defaultHeight)
                $0.isAutosizeEnabled = true
                if isTileEnabled(forSectionAt: section) {
                    var corners: UIRectCorner = .none
                    if !headerInfo.enabled, item == 0 {
                        corners.formUnion(.top)
                    }
                    if !footerInfo.enabled, item == itemCount - 1 {
                        corners.formUnion(.bottom)
                    }
                    $0.corners = (corners, cornerRadius)
                } else {
                    $0.corners = (.none, 0)
                }
                
                $0.offsetInSection = offsetInSection
            }
            layoutAttributes[indexPath] = attributes
            offsetInSection += attributes.size.height
            attributesBySection[section]?.append(attributes)
        }

        if footerInfo.enabled {
            let footerIndex = IndexPath(item: 0, section: section)
            let attributes = footerAttributes[section] ?? Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndex).apply {
                $0.size = CGSize(width: itemWidth, height: footerInfo.height ?? XCCollectionViewTileLayout.defaultHeight)
                $0.corners = isTileEnabled(forSectionAt: section) ? (.bottom, cornerRadius) : (.none, 0)
                $0.isAutosizeEnabled = footerInfo.height == nil
                $0.offsetInSection = offsetInSection
            }
            footerAttributes[section] = attributes
            offsetInSection += attributes.size.height
            attributesBySection[section]?.append(attributes)
        }
        return offsetInSection
    }

    private func calculateBackgroundAttributes() {
        guard let collectionView = self.collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            guard isTileEnabled(forSectionAt: section) else {
                continue
            }

            guard let backgroundRect = sectionRects[section], !backgroundRect.isEmpty else {
                continue
            }

            let attributes = sectionBackgroundAttributes[section] ?? Attributes(
                forDecorationViewOfKind: UICollectionElementKindSectionBackground,
                with: IndexPath(item: 0, section: section)
            ).apply {
                $0.corners = (.allCorners, cornerRadius)
                $0.zIndex = minimumItemZIndex - 2
            }
            sectionBackgroundAttributes[section] = attributes
        }
    }

    open override var collectionViewContentSize: CGSize {
        return CGSize(width: cachedContentSize.width + 0.001, height: cachedContentSize.height)
    }

    private func yAxisIntersection(element1: CGRect, element2: CGRect) -> ComparisonResult {
        if element1.maxY >= element2.minY, element2.maxY >= element1.minY {
            return .orderedSame
        }
        if element1.minY <= element2.minY {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elementsInRect = [Attributes]()
        for sectionsInColumn in sectionIndexesByColumn {
            guard let closestCandidateIndex = sectionsInColumn.binarySearch(
                target: rect,
                transform: { sectionRects[$0]! },
                yAxisIntersection
            ) else {
                continue
            }

            // Look Sections Below Candidate
            for sectionIndex in sectionsInColumn[..<closestCandidateIndex].reversed() {
                guard addAttributesOf(section: sectionIndex, within: rect, in: &elementsInRect) else {
                    break
                }
            }

            // Look Sections Under Candidate
            for sectionIndex in sectionsInColumn[closestCandidateIndex...] {
                guard addAttributesOf(section: sectionIndex, within: rect, in: &elementsInRect) else {
                    break
                }
            }
        }
        return elementsInRect
    }

    private func addAttributesOf(section sectionIndex: Int, within rect: CGRect, in elementsInRect: inout [Attributes]) -> Bool {
        let sectionRect = sectionRects[sectionIndex] ?? .zero
        guard yAxisIntersection(element1: rect, element2: sectionRects[sectionIndex]!) == .orderedSame else {
            return false
        }
        if let backgroundAttribute = sectionBackgroundAttributes[sectionIndex] {
            backgroundAttribute.frame = sectionRect
            elementsInRect.append(backgroundAttribute)
        }
        for attributes in attributesBySection[sectionIndex]! {
            attributes.frame.origin = CGPoint(x: sectionRect.origin.x, y: sectionRect.origin.y + attributes.offsetInSection)
            elementsInRect.append(attributes)
        }
        return true
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
    private var columnsHeight: [CGFloat] {
        var columnHeights = [CGFloat]()
        for columnSectionIndexes in sectionIndexesByColumn {
            if let lastIndex = columnSectionIndexes.last, let maxY = sectionRects[lastIndex]?.maxY {
                columnHeights.append(maxY)
            }
        }
        return columnHeights
    }

    private func minColumn(_ columns: [CGFloat]) -> (index: Int, height: CGFloat) {
        var index = 0
        var minYOffset = CGFloat.infinity
        for (i, columnOffset) in columns.enumerated() where columnOffset < minYOffset {
            minYOffset = columnOffset
            index = i
        }
        return (index, minYOffset)
    }

    private func maxColumn(_ columns: [CGFloat]) -> (index: Int, height: CGFloat) {
        var index = 0
        var maxYOffset: CGFloat = -1.0
        for (i, columnOffset) in columns.enumerated() where columnOffset > maxYOffset {
            maxYOffset = columnOffset
            index = i
        }
        return (index, maxYOffset)
    }

    private func getStoredAttribute(from originalAttributes: UICollectionViewLayoutAttributes) -> Attributes? {
        switch originalAttributes.representedElementCategory {
        case .cell:
            return layoutAttributes[originalAttributes.indexPath]
        case .supplementaryView:
            switch originalAttributes.representedElementKind {
            case UICollectionView.elementKindSectionHeader:
                return headerAttributes[originalAttributes.indexPath.section]
            case UICollectionView.elementKindSectionFooter:
                return footerAttributes[originalAttributes.indexPath.section]
            default:
                return nil
            }
        default:
            return nil
        }
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
        guard
            let collectionView = self.collectionView,
            let delegate = self.delegate
        else {
            return true
        }
        return delegate.collectionView(collectionView, layout: self, isTileEnabledInSection: section)
    }
}
