//
// IconLabelCollectionViewController.swift
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

@available(iOS 9.0, *)
public class IconLabelCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = IconLabelCollectionViewCell.reuseIdentifier
    public let layout = UICollectionViewFlowLayout()
    public var items: [ImageTitleDisplayable] = []
    public var allowReordering: Bool = true
    public var centerCells = false {
        didSet {
            if isViewLoaded() && centerCells {
                layout.minimumInteritemSpacing = view.bounds.height
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

    public init() {
        super.init(collectionViewLayout: layout)
        setupCollectionView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        let itemSpacing: CGFloat       = 8
        layout.itemSize                = CGSizeMake(60, 74)
        layout.minimumLineSpacing      = 15
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset            = UIEdgeInsetsMake(15, 15, 15, 15)
        layout.scrollDirection         = .Vertical
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor      = UIColor.clearColor()
        collectionView?.alwaysBounceVertical = true
        collectionView?.registerClass(IconLabelCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if centerCells {
            layout.minimumInteritemSpacing = view.bounds.height
        }
    }

    // MARK: UICollectionViewDataSource

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! IconLabelCollectionViewCell
        cell.setData(items[indexPath.item])
        configureCell?(indexPath: indexPath, cell: cell, item: items[indexPath.item])
        return cell
    }

    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        didSelectItem?(indexPath: indexPath, item: items[indexPath.item])
    }

    // MARK: Reordering

    public override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return allowReordering
    }

    public override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = items.removeAtIndex(sourceIndexPath.row)
        items.insert(itemToMove, atIndex: destinationIndexPath.row)
        didMoveItem?(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath, item: itemToMove)
    }

    // MARK: Deletion

    private func removeItemAt(indexPaths: [NSIndexPath]) {
        guard let collectionView = collectionView else { return }

        indexPaths.forEach {
            let item = items.removeAtIndex($0.item)
            didRemoveItem?(indexPath: $0, item: item)
        }

        collectionView.performBatchUpdates({
            collectionView.deleteItemsAtIndexPaths(indexPaths)
        }, completion: { isFinished in
            collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems())
        })
    }
}
