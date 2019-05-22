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
    private let numberOfColumns = 2
    
    private typealias Attributes = UICollectionViewFlexLayoutAttributes
    private var layoutAttributes: [IndexPath: Attributes] = [:]
    private var footerAttributes: [IndexPath: Attributes] = [:]
    private var headerAttributes: [IndexPath: Attributes] = [:]
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
        prepareBackgroundAttributes()
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
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var columnYOffset = [CGFloat](repeating: 0, count: numberOfColumns)

        layoutAttributes.removeAll()
        footerAttributes.removeAll()
        headerAttributes.removeAll()

        minYSectionAttribute.removeAll()
        maxYSectionAttribute.removeAll()

        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            guard itemCount > 0 else { continue }

            let currentColumn = minColumnIndex(columnYOffset)

            let sectionMargin = self.margin(forSectionAt: section)

             // first column -> full leading margin , other columns -> half leading margin
            // last column -> full trailing margin, other columns -> half trailing margin
            let leftMargin = currentColumn == 0 ? sectionMargin.left : sectionMargin.left / 2
            let rightMargin = currentColumn == numberOfColumns - 1 ? sectionMargin.right : sectionMargin.right / 2

            let availableWidth = columnWidth - leftMargin - rightMargin
            var offset = CGPoint(x: columnWidth * CGFloat(currentColumn) + leftMargin, y: columnYOffset[currentColumn])

            let sectionVerticalSpacing =  offset.y > 0 ? verticalSpacing(betweenSectionAt: section - 1, and: section) : 0

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
                    $0.corners = TileStyle.top.corners
                }
                headerAttributes[headerIndex] = attributes
                calculateMinMaxAttributes(with: attributes, in: section)
                offset.y += headerHeight
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let itemHeight = height(forItemAt: indexPath, width: availableWidth)
                if item > 0 {
                    offset.y += self.verticalSpacing(betweenItemAt: IndexPath(item: item - 1, section: section), and: indexPath)
                }

                let attributes = Attributes(forCellWith: indexPath).apply {
                    $0.size = CGSize(width: availableWidth, height: itemHeight)
                    $0.frame.origin.x = offset.x
                    $0.frame.origin.y = offset.y
                    $0.zIndex = zIndex(forItemAt: indexPath)
                    $0.cornerRadius = cornerRadius(forSectionAt: section)

                    var corners: UIRectCorner =  TileStyle.none.corners
                    if item == 0 && headerHeight == 0 {
                        corners.formUnion(TileStyle.top.corners)
                    }
                    if item == itemCount - 1 && footerHeight == 0 {
                        corners.formUnion(TileStyle.bottom.corners)
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
                    $0.corners = TileStyle.bottom.corners
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

    private func prepareBackgroundAttributes() {
        guard let collectionView = self.collectionView else { return }
        sectionBackgroundAttributes.removeAll()
        for section in 0..<collectionView.numberOfSections {
            guard
                isShadowEnabled(forSectionAt: section),
                let minYAttribute = self.minYSectionAttribute[section],
                let maxYAttribute = self.maxYSectionAttribute[section]
            else {
                continue
            }

            let minY = minYAttribute.frame.minY
            let maxY = maxYAttribute.frame.maxY
            let sectionMargin = self.margin(forSectionAt: section)
            let width = collectionView.frame.width - sectionMargin.left - sectionMargin.right
            let height = maxY - minY

            guard width > 0 && height > 0 else { continue }

            let attributes = Attributes(
                forDecorationViewOfKind: UICollectionElementKindSectionBackground,
                with: IndexPath(item: 0, section: section)
            )

            attributes.cornerRadius = cornerRadius(forSectionAt: section)
            attributes.corners = .allCorners

            attributes.frame = CGRect(
                x: sectionMargin.left,
                y: minY,
                width: width,
                height: height
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
        return layoutAttributes.values.filter { $0.frame.intersects(rect) }
            + sectionBackgroundAttributes.values.filter { $0.frame.intersects(rect) }
            + footerAttributes.values.filter { $0.frame.intersects(rect) }
            + headerAttributes.values.filter { $0.frame.intersects(rect) }
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.layoutAttributes[indexPath]
    }

    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return headerAttributes[indexPath]
            case UICollectionView.elementKindSectionFooter:
                return footerAttributes[indexPath]
            default:
                return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
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
}

private extension UICollectionViewFlexLayout {
    func minColumnIndex(_ columns: [CGFloat]) -> Int {
        var index = 0
        var minYOffset = CGFloat.infinity
        for (i, columnOffset) in columns.enumerated() {
            if columnOffset < minYOffset {
                minYOffset = columnOffset
                index = i
            }
        }
        return index
    }

    func maxColumnIndex(_ columns: [CGFloat]) -> Int {
        var index = 0
        var maxYOffset: CGFloat = -1.0
        for (i, columnOffset) in columns.enumerated() {
            if columnOffset > maxYOffset {
                maxYOffset = columnOffset
                index = i
            }
        }
        return index
    }
}

extension UICollectionViewFlexLayout {
    var delegate: UICollectionViewDelegateFlexLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlexLayout
    }

    public func height(forItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return .zero }
        return delegate.collectionView?(collectionView, layout: self, heightForItemAt: indexPath, width: width) ?? 0
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

    public func verticalSpacing(betweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        guard indexPath != nextIndexPath else { return 0 }
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, verticalSpacingBetweenItemAt: indexPath, and: nextIndexPath) ?? 0
    }

    public func zIndex(forItemAt indexPath: IndexPath) -> Int {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, zIndexForItemAt: indexPath) ?? 0
    }

    public func headerHeight(forSectionAt section: Int, width: CGFloat) -> CGFloat {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, heightForHeaderInSection: section, width: width) ?? 0
    }

    public func footerHeight(forSectionAt section: Int, width: CGFloat) -> CGFloat {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 0 }
        return delegate.collectionView?(collectionView, layout: self, heightForFooterInSection: section, width: width) ?? 0
    }

    public func cornerRadius(forSectionAt section: Int) -> CGFloat {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return 11 }
        return delegate.collectionView?(collectionView, layout: self, cornerRadiusAt: section) ?? 11
    }

    public func isShadowEnabled(forSectionAt section: Int) -> Bool {
        guard let collectionView = self.collectionView, let delegate = self.delegate else { return true }
        return delegate.collectionView?(collectionView, layout: self, isShadowEnabledAt: section) ?? true
    }
}
