//
// CollectionViewCarouselLayout.swift
//
// Copyright © 2016 Xcore
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

open class CollectionViewCarouselLayout: XCCollectionViewFlowLayout {
    public var interitemSpacing: CGFloat = 0
    public var lineSpacing: CGFloat = 0

    /// A property to store the most recent layout attributes for all elements in the `CarouselCollectionView`.
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []

    /// Return `true` so that the layout is continuously invalidated as the user scrolls.
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func prepare() {
        cachedAttributes.removeAll(keepingCapacity: false)
        super.prepare()
        computeAttributes()
    }

    open override class var layoutAttributesClass: AnyClass {
        return Attributes.self
    }

    open var shouldAddSeparators = false {
        didSet {
            guard oldValue != shouldAddSeparators else { return }
            invalidateLayout()
        }
    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        guard
            let collectionView = collectionView,
            (newBounds.height != collectionView.bounds.height) || (newBounds.width != collectionView.bounds.width),
            let context = super.invalidationContext(forBoundsChange: newBounds) as? UICollectionViewFlowLayoutInvalidationContext
        else {
            return super.invalidationContext(forBoundsChange: newBounds)
        }

        context.invalidateFlowLayoutDelegateMetrics = true
        context.invalidateFlowLayoutAttributes = true
        return context
    }

    /// Returns `contentSize` of the `CollectionView` (assuming this flow layout)
    open override var collectionViewContentSize: CGSize {
        // get x position of the last item in cachedAttributes (furthest one out in the x direction)
        guard
            let collectionView = collectionView,
            let furthestItemAttributes = cachedAttributes.last
        else {
            return super.collectionViewContentSize
        }

        var contentSize: CGSize = .zero

        switch scrollDirection {
            case .vertical:
                contentSize.width = collectionView.frame.width
                contentSize.height = furthestItemAttributes.frame.origin.y + furthestItemAttributes.frame.height
            case .horizontal:
                contentSize.width = furthestItemAttributes.frame.origin.x + furthestItemAttributes.frame.width
                contentSize.height = collectionView.frame.height
            @unknown default:
                break
        }

        return contentSize
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        let sectionsInRect = NSMutableIndexSet()
        var supplementaryLayoutAttributes = [UICollectionViewLayoutAttributes]()

        for layoutAttributesSet in layoutAttributes {
            sectionsInRect.add(layoutAttributesSet.indexPath.section)
        }

        for section in sectionsInRect {
            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: .header, at: IndexPath(item: 0, section: section)) {
                supplementaryLayoutAttributes.append(sectionAttributes)
            }
        }

        // We need all layout attributes to avoid potential UI glitches
        return cachedAttributes + supplementaryLayoutAttributes
    }
}

extension CollectionViewCarouselLayout {
    private func computeAttributes() {
        guard let collectionView = collectionView else {
            return
        }

        // holds a list of layout attributes for all elements about to be relaid out
        var attributes = [Attributes]()

        // Iterate through all items in the collectionView and lay them all out
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                if let attr = layoutAttributesForItem(at: IndexPath(item: item, section: section)) as? Attributes {
                    attributes.append(attr)
                }
            }
        }

        // get layout attributes of the element that preceeds the first element in the attributes var (we'll iteratively build our layout based on that cell)
        guard
            let first = attributes.first,
            var previousCellLayoutAttributes = attributes.at(max(0, first.indexPath.item - 1)) // used to keep track of the previous cell's origin/size
        else {
            return
        }

        for currentCellLayoutAttributes in attributes {
            var currentCellFrame = currentCellLayoutAttributes.frame

            // if the cell is at index path (0,0) then move its position to the top left of the contentView
            if currentCellLayoutAttributes.indexPath == .zero {
                currentCellFrame.origin = .zero
                if shouldAddSeparators {
                    currentCellLayoutAttributes.separator.insert(.top)
                }
            } else {
                switch scrollDirection {
                    case .vertical:
                        let cellCanFit = previousCellLayoutAttributes.frame.origin.x + previousCellLayoutAttributes.frame.width + interitemSpacing + currentCellLayoutAttributes.frame.width <= collectionView.frame.width
                        if cellCanFit {
                            currentCellLayoutAttributes.frame.origin.x = previousCellLayoutAttributes.frame.origin.x + previousCellLayoutAttributes.frame.width + interitemSpacing
                            currentCellLayoutAttributes.frame.origin.y = previousCellLayoutAttributes.frame.origin.y
                            currentCellLayoutAttributes.separator = previousCellLayoutAttributes.separator
                        } else {
                            currentCellLayoutAttributes.frame.origin.x = 0
                            currentCellLayoutAttributes.frame.origin.y = previousCellLayoutAttributes.frame.origin.y + previousCellLayoutAttributes.frame.height + lineSpacing
                        }
                    case .horizontal:
                        let cellCanFit = previousCellLayoutAttributes.frame.origin.y + previousCellLayoutAttributes.frame.height + interitemSpacing + currentCellLayoutAttributes.frame.height <= collectionView.frame.height
                        if cellCanFit {
                            currentCellLayoutAttributes.frame.origin.x = previousCellLayoutAttributes.frame.origin.x
                            currentCellLayoutAttributes.frame.origin.y = previousCellLayoutAttributes.frame.origin.y + previousCellLayoutAttributes.frame.height + interitemSpacing
                        } else {
                            currentCellLayoutAttributes.frame.origin.x = previousCellLayoutAttributes.frame.origin.x + previousCellLayoutAttributes.frame.width + lineSpacing
                            currentCellLayoutAttributes.frame.origin.y = 0
                        }
                    @unknown default:
                        break
                }
            }

            previousCellLayoutAttributes = currentCellLayoutAttributes // Make the current cell the new previous cell
        }

        cachedAttributes = attributes
        updateItemSize()
    }

    private func updateItemSize() {
        guard let _ = collectionView else {
            return
        }

        itemSize = cachedAttributes.first?.frame.size ?? .zero
    }
}
