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

open class XCCollectionViewTileLayout: UICollectionViewLayout, DimmableLayout {
    private let UICollectionElementKindSectionBackground = "UICollectionElementKindSectionBackground"
    private let UICollectionElementKindSectionStacked = "UICollectionElementKindSectionStacked"

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

    open var shouldDimElements = false {
        didSet {
            guard oldValue != shouldDimElements else { return }
            invalidateLayout()
        }
    }

    public var estimatedItemHeight: CGFloat = 200
    public var estimatedHeaderFooterHeight: CGFloat = 44

    private var cachedContentSize: CGSize = .zero
    public var shouldReloadAttributes = true
    private var minimumItemZIndex: Int = 0

    // Layout Elements
    private var attributesBySection = [[Attributes]]()
    private var layoutAttributes = [IndexPath: Attributes]()
    private var footerAttributes = [Int: Attributes]()
    private var headerAttributes = [Int: Attributes]()
    private var sectionBackgroundAttributes = [Int: Attributes]()
    private var firstParentIndexByIdentifier = [String: Int]()

    // Elements in rect calculation
    private var sectionRects = [CGRect]()
    private var sectionIndexesByColumn = [[Int]]()

    struct LayoutElements {
        var attributesBySection: [[Attributes]]
        var layoutAttributes: [IndexPath: Attributes]
        var footerAttributes: [Int: Attributes]
        var headerAttributes: [Int: Attributes]
        var sectionBackgroundAttributes: [Int: Attributes]
        var firstParentIndexByIdentifier: [String: Int]

        // Elements in rect calculation
        var sectionRects: [CGRect]
        var sectionIndexesByColumn: [[Int]]
    }

    private var beforeElements: LayoutElements?

    open override class var layoutAttributesClass: AnyClass {
        Attributes.self
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
        register(XCCollectionViewTileStackSelector.self, forDecorationViewOfKind: UICollectionElementKindSectionStacked)
    }

    open override func prepare() {
        super.prepare()

        guard !shouldReloadAttributes else {
            shouldReloadAttributes = false

            beforeElements = LayoutElements(
                attributesBySection: attributesBySection,
                layoutAttributes: layoutAttributes,
                footerAttributes: footerAttributes,
                headerAttributes: headerAttributes,
                sectionBackgroundAttributes: sectionBackgroundAttributes,
                firstParentIndexByIdentifier: firstParentIndexByIdentifier,
                sectionRects: sectionRects,
                sectionIndexesByColumn: sectionIndexesByColumn
            )

            sectionRects.removeAll()
            attributesBySection.removeAll()
            layoutAttributes.removeAll()
            footerAttributes.removeAll()
            headerAttributes.removeAll()
            sectionBackgroundAttributes.removeAll()
            firstParentIndexByIdentifier.removeAll()

            cachedContentSize = .zero
            calculateAttributes()
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
        guard let collectionView = collectionView else { return false }

        if newBounds.size != collectionView.bounds.size {
            shouldReloadAttributes = true
            return true
        }

        return false
    }

    private func calculateAttributes(shouldCreateAttributes: Bool = true) {
        guard let collectionView = self.collectionView else { return }
        let contentWidth: CGFloat = collectionView.bounds.width - horizontalMargin * 2.0
        let columnWidth = (contentWidth - (interColumnSpacing * CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)

        var offset: CGPoint = .zero
        var itemCount: Int = 0
        var tileEnabled: Bool = false
        var currentColumn: Int = 0
        var itemWidth: CGFloat = 0
        var margin: CGFloat = 0
        var verticalSpacing: CGFloat = 0

        var columnYOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        sectionIndexesByColumn.removeAll()
        for _ in 0..<numberOfColumns {
            sectionIndexesByColumn.append([Int]())
        }

        var zIndex = 0
        for section in 0..<collectionView.numberOfSections {
            itemCount = collectionView.numberOfItems(inSection: section)
            tileEnabled = isTileEnabled(forSectionAt: section)
            let parentIdentifier = self.parentIdentifier(forSectionAt: section)

            if numberOfColumns > 1 {
                currentColumn = tileEnabled ? minColumn(columnYOffset).index : maxColumn(columnYOffset).index
            }

            itemWidth = tileEnabled ? columnWidth : collectionView.frame.size.width
            margin = tileEnabled ? horizontalMargin : 0
            verticalSpacing = self.verticalSpacing(betweenSectionAt: section - 1, and: section)

            sectionIndexesByColumn[currentColumn].append(section)

            offset.x = tileEnabled ? (itemWidth + interColumnSpacing) * CGFloat(currentColumn) + margin : 0
            offset.y = columnYOffset[currentColumn]

            if itemCount > 0 {
                // Add vertical spacing
                offset.y += offset.y > 0 ? verticalSpacing : 0
            }

            let initialRect = CGRect(origin: offset, size: CGSize(width: itemWidth, height: 0))
            let sectionRect = createAttributes(for: section, rect: initialRect, itemCount: itemCount, zIndex: zIndex, alpha: 1.0, parentIdentifier: parentIdentifier)
            // Update height of section rect
            sectionRects.append(sectionRect)
            zIndex -= 1
            createBackgroundAttributes(for: section, zIndex: zIndex, alpha: 1.0, parentIdentifier: parentIdentifier)

            offset.y += sectionRects[section].height

            if let identifier = parentIdentifier {
                if firstParentIndexByIdentifier[identifier] == nil {
                    firstParentIndexByIdentifier[identifier] = section
                }
            }

            if tileEnabled {
                columnYOffset[currentColumn] = offset.y
            } else {
                for i in 0..<columnYOffset.count {
                    columnYOffset[i] = offset.y
                }
            }
        }

        cachedContentSize = CGSize(width: collectionView.bounds.width, height: self.maxColumn(self.columnsHeight).height + verticalSpacing)
    }

    private func createAttributes(for section: Int, rect: CGRect, itemCount: Int, zIndex: Int = 0, alpha: CGFloat, parentIdentifier: String?) -> CGRect {
        var sectionRect = rect
        var sectionAttributes = [Attributes]()
        guard itemCount > 0 else {
            attributesBySection.append(sectionAttributes)
            return sectionRect
        }

        let headerInfo = headerAttributes(in: section, width: sectionRect.width)
        let footerInfo = footerAttributes(in: section, width: sectionRect.width)

        if headerInfo.enabled {
            let headerIndex = IndexPath(item: 0, section: section)
            let attributes = Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: headerIndex).apply {
                $0.frame = CGRect(
                    x: sectionRect.origin.x,
                    y: sectionRect.maxY,
                    width: sectionRect.width,
                    height: headerInfo.height ?? estimatedHeaderHeight(in: section, width: sectionRect.width)
                )

                $0.corners = isTileEnabled(forSectionAt: section) ? (.top, cornerRadius(forSectionAt: section)) : (.none, 0)
                $0.shouldDim = shouldDimElements
                $0.zIndex = zIndex
                $0.alpha = alpha
                $0.parentIdentifier = parentIdentifier
            }

            headerAttributes[section] = attributes
            sectionRect.size.height += attributes.size.height
            sectionAttributes.append(attributes)
        }

        var indexPath = IndexPath(item: 0, section: section)
        var fixedHeight: CGFloat?
        for item in 0..<itemCount {
            indexPath.item = item
            fixedHeight = height(forItemAt: indexPath, width: sectionRect.width)
            let attributes = Attributes(forCellWith: indexPath).apply {
                $0.frame = CGRect(
                    x: sectionRect.origin.x,
                    y: sectionRect.maxY,
                    width: sectionRect.width,
                    height: fixedHeight ?? estimatedHeight(forItemAt: indexPath, width: sectionRect.width)
                )

                if isTileEnabled(forSectionAt: section) {
                    var corners: UIRectCorner = .none
                    if !headerInfo.enabled, item == 0 {
                        corners.formUnion(.top)
                    }
                    if !footerInfo.enabled, item == itemCount - 1 {
                        corners.formUnion(.bottom)
                    }
                    $0.corners = (corners, cornerRadius(forSectionAt: section))
                } else {
                    $0.corners = (.none, 0)
                }

                $0.shouldDim = shouldDimElements
                $0.zIndex = zIndex
                $0.alpha = alpha
                $0.parentIdentifier = parentIdentifier
            }
            layoutAttributes[indexPath] = attributes
            sectionRect.size.height += attributes.size.height
            sectionAttributes.append(attributes)
        }

        if footerInfo.enabled {
            let footerIndex = IndexPath(item: 0, section: section)
            let attributes = Attributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndex).apply {
                $0.frame = CGRect(
                    x: sectionRect.origin.x,
                    y: sectionRect.maxY,
                    width: sectionRect.width,
                    height: fixedHeight ?? estimatedFooterHeight(in: section, width: sectionRect.width)
                )
                $0.corners = isTileEnabled(forSectionAt: section) ? (.bottom, cornerRadius(forSectionAt: section)) : (.none, 0)
                $0.shouldDim = shouldDimElements
                $0.zIndex = zIndex
                $0.alpha = alpha
                $0.parentIdentifier = parentIdentifier
            }
            footerAttributes[section] = attributes
            sectionRect.size.height += attributes.size.height
            sectionAttributes.append(attributes)
        }
        attributesBySection.append(sectionAttributes)
        return sectionRect
    }

    private func createBackgroundAttributes(for section: Int, zIndex: Int, alpha: CGFloat, parentIdentifier: String?) {
        guard
            isShadowEnabled(forSectionAt: section),
            isTileEnabled(forSectionAt: section),
            !sectionRects[section].isEmpty
        else {
            return
        }

        let attributes = sectionBackgroundAttributes[section] ?? Attributes(
            forDecorationViewOfKind: UICollectionElementKindSectionBackground,
            with: IndexPath(item: 0, section: section)
        ).apply {
            $0.corners = (.allCorners, cornerRadius(forSectionAt: section))
            $0.zIndex = (attributesBySection[section].first?.zIndex ?? 0 ) - 1
            $0.shouldDim = shouldDimElements
            $0.frame = sectionRects[section]
            $0.zIndex = zIndex
            $0.alpha = alpha
            $0.parentIdentifier = parentIdentifier
        }
        sectionBackgroundAttributes[section] = attributes
    }

    open override var collectionViewContentSize: CGSize {
        .init(width: cachedContentSize.width, height: cachedContentSize.height)
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
                transform: { sectionRects[$0] },
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
        let sectionRect = sectionRects[sectionIndex]
        guard yAxisIntersection(element1: rect, element2: sectionRect) == .orderedSame else {
            return false
        }
        elementsInRect.append(contentsOf: attributesBySection[sectionIndex])
        if let backgroundAttributes = sectionBackgroundAttributes[sectionIndex] {
            elementsInRect.append(backgroundAttributes)
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

    open override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("This will be deleted \(itemIndexPath)")
        guard let beforeElements = beforeElements else {
            return nil
        }

        if let attributes = beforeElements.layoutAttributes[itemIndexPath] {
            // Moved items
            if let newAttributes = layoutAttributes[itemIndexPath] {
                guard let returnAttributes = newAttributes.copy() as? Attributes else { return nil }
                return returnAttributes
            }

            // Stacked items go to their parents origin
            if
                let parentIdentifier = attributes.parentIdentifier,
                let parentSectionIndex = beforeElements.firstParentIndexByIdentifier[parentIdentifier]
            {
                attributes.frame.origin = sectionRects[parentSectionIndex].origin
            }
            attributes.alpha = 0
            return attributes
        }
        return nil
    }

    open override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("This will be added \(itemIndexPath)")
        guard let beforeElements = beforeElements else {
            return nil
        }

        if let attributes = layoutAttributes[itemIndexPath] {
            // Stacked items
            if
                let parentIdentifier = attributes.parentIdentifier,
                let parentSectionIndex = firstParentIndexByIdentifier[parentIdentifier]
            {
                guard let newAttributes = attributes.copy() as? Attributes else { return nil }
                newAttributes.frame.origin = beforeElements.sectionRects[parentSectionIndex].origin
                return newAttributes
            }

            // Moved items
            if let oldAttributes = beforeElements.layoutAttributes[itemIndexPath] {
                 return oldAttributes
            }
            
            // New Items
            guard let newAttributes = attributes.copy() as? Attributes else { return nil }
            newAttributes.alpha = 0.0
            return newAttributes
        }

        return nil
    }

    open override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("This decorative will be added \(decorationIndexPath)")
        guard let beforeElements = beforeElements else {
            return nil
        }
        // Moved items
        if let attributes = beforeElements.sectionBackgroundAttributes[decorationIndexPath.section] {
             return attributes
        }
        // Inserted items
        if let attributes = sectionBackgroundAttributes[decorationIndexPath.section] {
            guard
                let parentIdentifier = attributes.parentIdentifier,
                let parentSectionIndex = firstParentIndexByIdentifier[parentIdentifier],
                parentSectionIndex != decorationIndexPath.section
            else {
                return nil
            }
            guard let newAttributes = attributes.copy() as? Attributes else { return nil }
            newAttributes.frame.origin = sectionRects[parentSectionIndex].origin
            return newAttributes
        }
        return nil
    }

    open override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
                guard let beforeElements = beforeElements else {
            return nil
        }

        // Stacked items go to their parents origin
        if let attributes = beforeElements.sectionBackgroundAttributes[decorationIndexPath.section] {
            guard
                let parentIdentifier = attributes.parentIdentifier,
                let parentSectionIndex = beforeElements.firstParentIndexByIdentifier[parentIdentifier],
                parentSectionIndex != decorationIndexPath.section
            else {
                return nil
            }
            attributes.frame.origin = sectionRects[parentSectionIndex].origin
            return attributes
        }
        return nil
    }
}

extension XCCollectionViewTileLayout {
    private var columnsHeight: [CGFloat] {
        var columnHeights = [CGFloat]()
        for columnSectionIndexes in sectionIndexesByColumn {
            if let lastIndex = columnSectionIndexes.last {
                columnHeights.append(sectionRects[lastIndex].maxY)
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
        collectionView?.delegate as? XCCollectionViewDelegateTileLayout
    }

    private func height(forItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return nil
        }

        return delegate.collectionView(collectionView, layout: self, heightForItemAt: indexPath, width: width)
    }

    private func headerAttributes(in section: Int, width: CGFloat) -> (enabled: Bool, height: CGFloat?) {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return (false, nil)
        }

        return delegate.collectionView(collectionView, layout: self, headerAttributesInSection: section, width: width)
    }

    private func footerAttributes(in section: Int, width: CGFloat) -> (enabled: Bool, height: CGFloat?) {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return (false, nil)
        }

        return delegate.collectionView(collectionView, layout: self, footerAttributesInSection: section, width: width)
    }

    private func estimatedHeight(forItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return estimatedItemHeight
        }

        return delegate.collectionView(collectionView, layout: self, estimatedHeightForItemAt: indexPath, width: width)
    }

    private func estimatedHeaderHeight(in section: Int, width: CGFloat) -> CGFloat {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return estimatedHeaderFooterHeight
        }

        return delegate.collectionView(collectionView, layout: self, estimatedHeaderHeightInSection: section, width: width)
    }

    private func estimatedFooterHeight(in section: Int, width: CGFloat) -> CGFloat {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return estimatedHeaderFooterHeight
        }

        return delegate.collectionView(collectionView, layout: self, estimatedFooterHeightInSection: section, width: width)
    }

    private func verticalSpacing(betweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        guard
            section != nextSection,
            let collectionView = collectionView,
            let delegate = delegate,
            section >= 0
        else {
            return 0
        }

        return delegate.collectionView(collectionView, layout: self, verticalSpacingBetweenSectionAt: section, and: nextSection)
    }

    private func isTileEnabled(forSectionAt section: Int) -> Bool {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return true
        }

        return delegate.collectionView(collectionView, layout: self, isTileEnabledInSection: section)
    }

    private func isShadowEnabled(forSectionAt section: Int) -> Bool {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return true
        }

        return delegate.collectionView(collectionView, layout: self, isShadowEnabledInSection: section)
    }

    private func cornerRadius(forSectionAt section: Int) -> CGFloat {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return cornerRadius
        }

        return delegate.collectionView(collectionView, layout: self, cornerRadiusInSection: section)
    }

    private func parentIdentifier(forSectionAt section: Int) -> String? {
        guard
            let collectionView = collectionView,
            let delegate = delegate
        else {
            return nil
        }

        return delegate.collectionView(collectionView, layout: self, parentIdentifierInSection: section)
    }
}
