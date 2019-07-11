//
// IconLabelCollectionView.swift
//
// Copyright © 2015 Xcore
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

open class IconLabelCollectionView: UICollectionView {
    private var allowsReordering: Bool { return cellOptions.contains(.move) }
    private var allowsDeletion: Bool { return cellOptions.contains(.delete) }
    private var hasLongPressGestureRecognizer = false
    open var sections: [Section<ImageTitleDisplayable>] = []

    /// The layout used to organize the collection view’s items.
    open var layout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }

    open var cellOptions: CellOptions = .none {
        didSet {
            updateCellOptionsIfNeeded()
        }
    }

    open var isEditing = false {
        didSet {
            guard oldValue != isEditing else { return }
            tapGestureRecognizer.isEnabled = isEditing
            toggleVisibleCellsDeleteButtons()
        }
    }

    /// A boolean value to determine whether the content is centered in the collection view.
    /// The default value is `false`.
    open var isContentCentered = false {
        didSet {
            guard isContentCentered else { return }
            layout?.minimumInteritemSpacing = bounds.height
        }
    }

    private var configureCell: ((_ indexPath: IndexPath, _ cell: Cell, _ item: ImageTitleDisplayable) -> Void)?
    open func configureCell(_ callback: @escaping (_ indexPath: IndexPath, _ cell: Cell, _ item: ImageTitleDisplayable) -> Void) {
        configureCell = callback
    }

    private var didSelectItem: ((_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didSelectItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
        didSelectItem = callback
    }

    private var didRemoveItem: ((_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didRemoveItem(_ callback: @escaping (_ indexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
        didRemoveItem = callback
    }

    private var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void)?
    open func didMoveItem(_ callback: @escaping (_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath, _ item: ImageTitleDisplayable) -> Void) {
        didMoveItem = callback
    }

    // MARK: - Init Methods

    public convenience init() {
        self.init(options: [])
    }

    public convenience init(frame: CGRect) {
        self.init(frame: frame, options: [])
    }

    public convenience init(frame: CGRect = .zero, collectionViewLayout: UICollectionViewLayout? = nil, options: CellOptions) {
        self.init(frame: frame, collectionViewLayout: collectionViewLayout ?? UICollectionViewFlowLayout())
        cellOptions = options
    }

    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        internalCommonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalCommonInit()
    }

    // MARK: - Setup Methods

    private func internalCommonInit() {
        setupCollectionView()
        commonInit()
    }

    /// The default implementation of this method does nothing.
    ///
    /// Subclasses can override it to perform additional actions, for example, add
    /// new subviews or configure properties. This method is called when `self` is
    /// initialized using any of the relevant `init` methods.
    open func commonInit() {}

    private func setupCollectionView() {
        delegate = self
        dataSource = self
        backgroundColor = .clear
        alwaysBounceVertical = true

        layout?.apply {
            $0.itemSize = CGSize(width: 60, height: 74)
            $0.minimumLineSpacing = .defaultPadding
            $0.minimumInteritemSpacing = .minimumPadding
            $0.sectionInset = .defaultPadding
            $0.scrollDirection = .vertical
        }

        updateCellOptionsIfNeeded()
    }

    open override func reloadData() {
        isEditing = false
        super.reloadData()
    }

    // MARK: - UILongPressGestureRecognizer

    private lazy var longPressGestureRecognizer = UILongPressGestureRecognizer { [weak self] sender in
        guard
            let strongSelf = self,
            sender.state == .began,
            strongSelf.indexPathForItem(at: sender.location(in: strongSelf)) != nil
        else { return }

        strongSelf.isEditing.toggle()
    }

    private lazy var tapGestureRecognizer = UITapGestureRecognizer().apply {
        $0.isEnabled = false
        $0.addAction { [weak self] _ in
            self?.isEditing = false
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension IconLabelCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as Cell
        let item = sections[indexPath]
        cell.configure(item, at: indexPath, collectionView: self)
        configureCell?(indexPath, cell, item)
        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = sections[indexPath]
        didSelectItem?(indexPath, item)
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard allowsDeletion, let cell = cell as? Cell else { return }
        cell.setDeleteButtonHidden(!isEditing)
    }

    // MARK: - Reordering

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return allowsReordering
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedItem = sections.moveElement(from: sourceIndexPath, to: destinationIndexPath)
        didMoveItem?(sourceIndexPath, destinationIndexPath, movedItem)
    }
}

// MARK: - Deletion

extension IconLabelCollectionView {
    /// Deletes the items at the specified index paths.
    ///
    /// - Parameter indexPaths: An array of `IndexPath` objects identifying the items to delete.
    open func removeItems(_ indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let item = sections.remove(at: $0)
            didRemoveItem?($0, item)
        }

        performBatchUpdates({ [weak self] in
            self?.deleteItems(at: indexPaths)
        }, completion: { [weak self] isFinished in
            guard let strongSelf = self else { return }
            strongSelf.reloadItems(at: strongSelf.indexPathsForVisibleItems)
        })
    }
}

// MARK: - Convenience API

extension IconLabelCollectionView {
    /// A convenience property to create a single section collection view.
    open var items: [ImageTitleDisplayable] {
        get { return sections.first?.items ?? [] }
        set { sections = [Section(items: newValue)] }
    }
}

// MARK: - Helpers

extension IconLabelCollectionView {
    private func updateCellOptionsIfNeeded() {
        if allowsDeletion && !hasLongPressGestureRecognizer {
            addGestureRecognizer(tapGestureRecognizer)
            addGestureRecognizer(longPressGestureRecognizer)
            hasLongPressGestureRecognizer = true
        } else if !allowsDeletion && hasLongPressGestureRecognizer {
            isEditing = false
            removeGestureRecognizer(tapGestureRecognizer)
            removeGestureRecognizer(longPressGestureRecognizer)
            hasLongPressGestureRecognizer = false
        }
    }

    private func toggleVisibleCellsDeleteButtons() {
        visibleCells.compactMap { $0 as? Cell }.forEach {
            $0.setDeleteButtonHidden(!isEditing)
        }
    }
}
