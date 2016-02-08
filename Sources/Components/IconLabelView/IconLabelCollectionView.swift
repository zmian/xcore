//
// IconLabelCollectionView.swift
//
// Copyright © 2015 Zeeshan Mian
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

public struct IconLabelCollectionCellOptions: OptionSetType {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }

    public static let Movable                             = IconLabelCollectionCellOptions(rawValue: 1)
    public static let Deletable                           = IconLabelCollectionCellOptions(rawValue: 2)
    public static let All: IconLabelCollectionCellOptions = [Movable, Deletable]
}

public typealias IconLabelCollectionViewDataSourceModel = [ImageTitleDisplayable]

public class IconLabelCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    private let reuseIdentifier = IconLabelCollectionViewCell.reuseIdentifier
    public var sections: [IconLabelCollectionViewDataSourceModel] = []
    /// The layout used to organize the collection view’s items.
    public var layout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
    public private(set) var cellOptions: IconLabelCollectionCellOptions = []
    private var allowReordering: Bool { return cellOptions.contains(.Movable) }
    private var allowDeletion: Bool   { return cellOptions.contains(.Deletable) }
    public var centerCells = false {
        didSet {
            if centerCells {
                layout?.minimumInteritemSpacing = bounds.height
            }
        }
    }

    private var configureCell: ((indexPath: NSIndexPath, cell: IconLabelCollectionViewCell, item: ImageTitleDisplayable) -> Void)?
    public func configureCell(callback: (indexPath: NSIndexPath, cell: IconLabelCollectionViewCell, item: ImageTitleDisplayable) -> Void) {
        configureCell = callback
    }

    private var didSelectItem: ((indexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void)?
    public func didSelectItem(callback: (indexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void) {
        didSelectItem = callback
    }

    private var didRemoveItem: ((indexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void)?
    public func didRemoveItem(callback: (indexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void) {
        didRemoveItem = callback
    }

    private var didMoveItem: ((sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void)?
    public func didMoveItem(callback: (sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath, item: ImageTitleDisplayable) -> Void) {
        didMoveItem = callback
    }

    // MARK: Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, options: [])
    }

    public convenience init(frame: CGRect = .zero, collectionViewLayout: UICollectionViewLayout? = nil, options: IconLabelCollectionCellOptions) {
        self.init(frame: frame, collectionViewLayout: collectionViewLayout ?? UICollectionViewFlowLayout())
    }

    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Setup Methods

    private func commonInit() {
        setupCollectionView()
        setupSubviews()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// for example, add new subviews or configure properties.
    /// This method is called when self is initialized using any of the relevant `init` methods.
    public func setupSubviews() {}

    private func setupCollectionView() {
        delegate             = self
        dataSource           = self
        backgroundColor      = UIColor.clearColor()
        alwaysBounceVertical = true
        registerClass(IconLabelCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let itemSpacing: CGFloat        = 8
        layout?.itemSize                = CGSize(width: 60, height: 74)
        layout?.minimumLineSpacing      = 15
        layout?.minimumInteritemSpacing = itemSpacing
        layout?.sectionInset            = UIEdgeInsets(all: 15)
        layout?.scrollDirection         = .Vertical
    }

    // MARK: UICollectionViewDataSource

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! IconLabelCollectionViewCell
        let item = sections[indexPath.section][indexPath.item]
        cell.setData(item)
        configureCell?(indexPath: indexPath, cell: cell, item: item)
        return cell
    }

    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        let item = sections[indexPath.section][indexPath.item]
        didSelectItem?(indexPath: indexPath, item: item)
    }

    // MARK: Reordering

    public func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowReordering
    }

    public func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = sections[sourceIndexPath.section].removeAtIndex(sourceIndexPath.item)
        sections[destinationIndexPath.section].insert(itemToMove, atIndex: destinationIndexPath.item)
        didMoveItem?(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath, item: itemToMove)
    }

    // MARK: Deletion

    /// Deletes the items at the specified index paths.
    ///
    /// - parameter indexPaths: An array of NSIndexPath objects identifying the items to delete.
    public func removeItems(indexPaths: [NSIndexPath]) {
        indexPaths.forEach {
            let item = sections[$0.section].removeAtIndex($0.item)
            didRemoveItem?(indexPath: $0, item: item)
        }

        performBatchUpdates({[weak self] in
            self?.deleteItemsAtIndexPaths(indexPaths)
        }, completion: {[weak self] isFinished in
            guard let weakSelf = self else { return }
            weakSelf.reloadItemsAtIndexPaths(weakSelf.indexPathsForVisibleItems())
        })
    }
}

// MARK: Convenience API

public extension IconLabelCollectionView {
    /// A convenience property to create a single section collection view.
    public var items: [ImageTitleDisplayable] {
        get { return sections.first ?? [] }
        set { sections = [newValue] }
    }
}
