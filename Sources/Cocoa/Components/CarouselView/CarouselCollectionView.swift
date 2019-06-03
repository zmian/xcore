//
// CarouselCollectionView.swift
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

extension CustomCarouselView {
    public enum Style {
        case `default`
        case infiniteScroll
        case multipleItemsPerPage
    }
}

final class CarouselCollectionView
    <Cell: CarouselViewCellType, Model: CarouselViewModelRepresentable>:
    UICollectionView,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSourcePrefetching
    where Cell.Model == Model.Model
{
    private var ignoreScrollEventsCallbacks = false
    private var autoScrollTimer: Timer?

    var layout: CollectionViewCarouselLayout {
        return collectionViewLayout as! CollectionViewCarouselLayout
    }

    var viewModel: Model? {
        didSet {
            reloadData()
        }
    }

    /// The specific carousel style (e.g., infinite scroll or multiple items per
    /// page).
    ///
    /// The default value is `.default`.
    var style: CustomCarouselView<Cell, Model>.Style = .default

    private var previousIndex: Int = 0

    var currentIndex: Int {
        if bounds.width == 0 {
            layoutIfNeeded()
        }

        guard bounds.width > 0, numberOfItems > 0 else {
            return 0
        }

        if style == .infiniteScroll {
            return (Int(round(adjustedOffset / bounds.width)) + numberOfItems) % numberOfItems
        }

        return Int(round(adjustedOffset / bounds.width))
    }

    var numberOfItems: Int {
        return viewModel?.numberOfItems() ?? 0
    }

    var numberOfPages: Int {
        guard style == .multipleItemsPerPage else {
            return numberOfItems
        }

        // The number of pages is dependant on the layout of the items, we need to layout
        // before getting the content size, and the number of pages.
        if bounds.width == 0 || numberOfItems > 0 && contentSize.width == 0 {
            layoutIfNeeded()
        }

        guard bounds.width > 0 else {
            return 0
        }
        return Int(contentSize.width / bounds.width)
    }

    private var adjustedOffset: CGFloat {
        return contentOffset.x + (style == .infiniteScroll ? -bounds.width : 0)
    }

    var height: CGFloat {
        let cell: Cell = CollectionViewDequeueCache.shared.dequeueCell()
        let width = cell.preferredWidth(collectionView: self)
        return cell.contentView.sizeFitting(width: width).height
    }

    // MARK: - Init Methods

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: CollectionViewCarouselLayout())
    }

    override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        delegate = self
        dataSource = self
        prefetchDataSource = self
        backgroundColor = .clear
        alwaysBounceHorizontal = true
        alwaysBounceVertical = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true

        layout.apply {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
            $0.sectionInset = .zero
        }
    }

    // MARK: - DataSource & Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard numberOfItems > 0 else { return 0 }
        if style == .infiniteScroll {
            return numberOfItems + 2
        }
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as Cell
        let item = adjustedItemForInfiniteScroll(at: indexPath.item)
        guard let itemViewModel = viewModel?.itemViewModel(index: item) else { return cell }

        cell.configure(itemViewModel)
        didConfigure?(indexPath.item, itemViewModel, cell)

        cell.didSelectItem { [weak self] in
            self?.didSelectItem?(item, itemViewModel)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            prefetch?(indexPath.item)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard style == .multipleItemsPerPage else {
            return collectionView.bounds.size
        }

        let cell: Cell = CollectionViewDequeueCache.shared.dequeueCell()

        guard let itemViewModel = viewModel?.itemViewModel(index: indexPath.item) else {
            return .zero
        }

        cell.configure(itemViewModel)
        return cell.contentView.sizeFitting(width: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemViewModel = viewModel?.itemViewModel(index: indexPath.item) else { return }
        didSelectItem?(indexPath.item, itemViewModel)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        autoScrollTimer?.invalidate()
        previousIndex = currentIndex
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !ignoreScrollEventsCallbacks else { return }
        didScroll?(currentIndex, previousIndex, scrollView)

        UIAccessibility.post(notification: .layoutChanged, argument: nil)

        // `scrollViewDidEndDecelerating` isn't fired when voice over is running this
        // ensures that we keep the client api consistent regardless of the device
        // accessibility state.
        if UIAccessibility.isVoiceOverRunning {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let item = viewModel?.itemViewModel(index: currentIndex) else {
            return
        }

        adjustInfiniteScrollContentOffset()

        previousIndex = currentIndex
        if !ignoreScrollEventsCallbacks {
            didChangeCurrentItem?(currentIndex, item)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let autoScrollTimer = autoScrollTimer else { return }
        startAutoScrolling(autoScrollTimer.timeInterval)
    }

    // MARK: - API

    func setCurrentIndex(_ index: Int, animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard currentIndex != index else { return }

        layoutIfNeeded()
        CATransaction.animationTransaction({
            ignoreScrollEventsCallbacks = true
            setContentOffset(CGPoint(x: offset(forPage: index), y: 0), animated: animated)
        }, completionHandler: { [weak self] in
            self?.ignoreScrollEventsCallbacks = false
            completionHandler?()
        })
    }

    private var didScroll: ((_ index: Int, _ previousIndex: Int, _ scrollView: UIScrollView) -> Void)?
    func didScroll(_ callback: @escaping (_ index: Int, _ previousIndex: Int, _ scrollView: UIScrollView) -> Void) {
        didScroll = callback
    }

    private var didSelectItem: ((_ index: Int, _ item: Cell.Model) -> Void)?
    func didSelectItem(_ callback: @escaping (_ index: Int, _ item: Cell.Model) -> Void) {
        didSelectItem = callback
    }

    private var didChangeCurrentItem: ((_ index: Int, _ item: Cell.Model) -> Void)?
    func didChangeCurrentItem(_ callback: @escaping (_ index: Int, _ item: Cell.Model) -> Void) {
        didChangeCurrentItem = callback
    }

    private var didConfigure: ((_ index: Int, _ item: Cell.Model, _ cell: Cell) -> Void)?
    func didConfigure(_ callback: @escaping (_ index: Int, _ item: Cell.Model, _ cell: Cell) -> Void) {
        didConfigure = callback
    }

    private var prefetch: ((_ index: Int) -> Void)?
    func prefetch(_ callback: @escaping ((_ index: Int) -> Void)) {
        prefetch = callback
    }
}

// MARK: - Autoscroll

extension CarouselCollectionView {
    func startAutoScrolling(_ interval: TimeInterval = .slow) {
        autoScrollTimer?.invalidate()
        autoScrollTimer = Timer.schedule(repeatInterval: interval) { [weak self] in
            self?.scrollToNextPage()
        }
    }

    func stopAutoScrolling() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    func scrollToNextPage() {
        guard
            let state = UIApplication.sharedOrNil?.applicationState,
            state == .active
        else {
            return
        }

        adjustInfiniteScrollContentOffset()
        setCurrentIndex(currentIndex + 1)
    }

    func scrollToPreviousPage() {
        guard
            let state = UIApplication.sharedOrNil?.applicationState,
            state == .active
        else {
            return
        }

        guard currentIndex > 0 else { return }
        setCurrentIndex(currentIndex - 1)
    }
}

// MARK: - Private Helpers

extension CarouselCollectionView {
    private func adjustedItemForInfiniteScroll(at index: Int) -> Int {
        guard style == .infiniteScroll else { return index }

        if index == 0 { // Left end of infinite scroll
            return numberOfItems - 1
        } else if index == numberOfItems + 1 { // Right end of infinite scroll
            return 0
        } else {
            return index - 1 // Adjusted index
        }
    }

    private func offset(forPage page: Int) -> CGFloat {
        let offset = CGFloat(page) * bounds.width
        if style == .infiniteScroll {
            return offset + bounds.width
        }
        return offset
    }

    private func adjustInfiniteScrollContentOffset() {
        guard style == .infiniteScroll else { return }
        // If we are standing on the begining or end of the scroll view we need to place
        // the offset in the same spot (page) but  with a next and a previous page
        // within the scroll
        let lastPage = numberOfItems(inSection: 0)
        let lastPageOffset = CGFloat(lastPage - 1) * bounds.width
        if contentOffset.x == lastPageOffset || contentOffset.x == 0 {
            contentOffset = CGPoint(x: offset(forPage: currentIndex), y: 0)
        }
    }
}
