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

public struct IconLabelCollectionCellOptions: OptionSet {
    public let rawValue: UInt
    public init(rawValue: UInt) { self.rawValue = rawValue }

    public static let movable                             = IconLabelCollectionCellOptions(rawValue: 1)
    public static let deletable                           = IconLabelCollectionCellOptions(rawValue: 2)
    public static let all: IconLabelCollectionCellOptions = [movable, deletable]
}

open class IconLabelCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    fileprivate let reuseIdentifier = IconLabelCollectionViewCell.reuseIdentifier
    fileprivate var allowReordering: Bool { return cellOptions.contains(.movable) }
    fileprivate var allowDeletion: Bool   { return cellOptions.contains(.deletable) }
    fileprivate var hasLongPressGestureRecognizer = false
    open var sections: [Section<ImageTitleDisplayable>] = []
    /// The layout used to organize the collection view’s items.
    open var layout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }
    open var cellOptions: IconLabelCollectionCellOptions = [] {
        didSet { updateCellOptionsIfNeeded() }
    }

    open var isEditing = false {
        didSet {
            guard oldValue != isEditing else { return }
            tapGestureRecognizer.isEnabled = isEditing
            toggleVisibleCellsDeleteButtons()
        }
    }

    /// A boolean value to determine whether the content is centered in the collection view. The default value is `false`.
    open var isContentCentered = false {
        didSet {
            if isContentCentered {
                layout?.minimumInteritemSpacing = bounds.height
            }
        }
    }

    fileprivate var configureCell: ((_ indexPath: IndexPath, _ cell: IconLabelCollectionViewCell, _ item: ImageTitleDisplayable) -> Void)?
    open func configureCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: IconLabelCollectionViewCell, _ item: ImageTitleDisplayable) -> Void) {
        configureCell = callback
    }

    fileprivate var didSelectItem: ((_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didSelectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
        didSelectItem = callback
    }

    fileprivate var didRemoveItem: ((_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didRemoveItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
        didRemoveItem = callback
    }

    fileprivate var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didMoveItem(_ callback: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
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
        cellOptions = options
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

    fileprivate func commonInit() {
        setupCollectionView()
        setupSubviews()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions,
    /// for example, add new subviews or configure properties.
    /// This method is called when self is initialized using any of the relevant `init` methods.
    open func setupSubviews() {}

    fileprivate func setupCollectionView() {
        delegate             = self
        dataSource           = self
        backgroundColor      = .clear
        alwaysBounceVertical = true
        register(IconLabelCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let itemSpacing: CGFloat        = 8
        layout?.itemSize                = CGSize(width: 60, height: 74)
        layout?.minimumLineSpacing      = 15
        layout?.minimumInteritemSpacing = itemSpacing
        layout?.sectionInset            = UIEdgeInsets(all: 15)
        layout?.scrollDirection         = .vertical

        updateCellOptionsIfNeeded()
    }

    open override func reloadData() {
        isEditing = false
        super.reloadData()
    }

    // MARK: UILongPressGestureRecognizer

    fileprivate lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let gestureRecognizer = UILongPressGestureRecognizer()

        gestureRecognizer.addAction {[weak self, weak gestureRecognizer] in
            guard let weakSelf = self, let gestureRecognizer = gestureRecognizer else { return }

            guard gestureRecognizer.state == .began,
                let _ = weakSelf.indexPathForItem(at: gestureRecognizer.location(in: weakSelf))
                else { return }

            weakSelf.isEditing = !weakSelf.isEditing
        }

        return gestureRecognizer
    }()

    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.isEnabled = false

        gestureRecognizer.addAction {[weak self] in
            self?.isEditing = false
        }

        return gestureRecognizer
    }()

    // MARK: UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IconLabelCollectionViewCell
        let item = sections[indexPath]
        cell.setData(item)
        cell.setDeleteButtonHidden(!isEditing, animated: false)
        cell.deleteButton.addAction(.touchUpInside) {[weak self] sender in
            self?.removeItems([indexPath])
        }
        configureCell?(indexPath, cell, item)
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = sections[indexPath]
        didSelectItem?(indexPath, item)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard allowDeletion, let cell = cell as? IconLabelCollectionViewCell else { return }
        cell.setDeleteButtonHidden(!isEditing)
    }

    // MARK: Reordering

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return allowReordering
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = sections.moveElement(fromIndexPath: sourceIndexPath, toIndexPath: destinationIndexPath)
        didMoveItem?(sourceIndexPath, destinationIndexPath, movedItem)
    }

    // MARK: Deletion

    /// Deletes the items at the specified index paths.
    ///
    /// - parameter indexPaths: An array of `IndexPath` objects identifying the items to delete.
    open func removeItems(_ indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let item = sections.remove(at: $0)
            didRemoveItem?($0, item)
        }

        performBatchUpdates({[weak self] in
            self?.deleteItems(at: indexPaths)
        }, completion: {[weak self] isFinished in
            guard let weakSelf = self else { return }
            weakSelf.reloadItems(at: weakSelf.indexPathsForVisibleItems)
        })
    }

    // MARK: Helpers

    fileprivate func updateCellOptionsIfNeeded() {
        if allowDeletion && !hasLongPressGestureRecognizer {
            addGestureRecognizer(tapGestureRecognizer)
            addGestureRecognizer(longPressGestureRecognizer)
            hasLongPressGestureRecognizer = true
        } else if !allowDeletion && hasLongPressGestureRecognizer {
            isEditing = false
            removeGestureRecognizer(tapGestureRecognizer)
            removeGestureRecognizer(longPressGestureRecognizer)
            hasLongPressGestureRecognizer = false
        }
    }

    fileprivate func toggleVisibleCellsDeleteButtons() {
        visibleCells.flatMap { $0 as? IconLabelCollectionViewCell }.forEach { $0.setDeleteButtonHidden(!isEditing) }
    }

    // MARK: Convenience API

    // Note: This is here instead of separate extension because Swift doesn't allow us to `override`
    // property declared in an extension.

    /// A convenience property to create a single section collection view.
    open var items: [ImageTitleDisplayable] {
        get { return sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }
}
