//
// UITableView+Extensions.swift
//
// Copyright © 2014 Xcore
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

extension UITableView {
    /// Compares the top two visible rows to the current content offset
    /// and returns the best index path that is visible on the top.
    public var visibleTopIndexPath: IndexPath? {
        let visibleRows = indexPathsForVisibleRows ?? []
        let firstPath: IndexPath
        let secondPath: IndexPath

        if visibleRows.isEmpty {
            return nil
        } else if visibleRows.count == 1 {
            return visibleRows.first
        } else {
            firstPath = visibleRows[0]
            secondPath = visibleRows[1]
        }

        let firstRowRect = rectForRow(at: firstPath)
        return firstRowRect.origin.y > contentOffset.y ? firstPath : secondPath
    }

    /// A convenience property for the index paths representing the selected rows.
    /// This simply return empty array when there are no selected rows instead of `nil`.
    ///
    /// ```swift
    /// return indexPathsForSelectedRows ?? []
    /// ```
    public var selectedIndexPaths: [IndexPath] {
        return indexPathsForSelectedRows ?? []
    }

    /// The total number of rows in all the sections.
    public var numberOfRowsInAllSections: Int {
        var rows = 0
        for i in 0..<numberOfSections {
            rows += numberOfRows(inSection: i)
        }
        return rows
    }

    /// Selects a row in the table view identified by index path, optionally scrolling the row to a location in the table view.
    ///
    /// Calling this method does not cause the delegate to receive a `tableView:willSelectRowAtIndexPath:` or
    /// `tableView:didSelectRowAtIndexPath:` message, nor does it send `UITableViewSelectionDidChangeNotification`
    /// notifications to observers.
    ///
    /// Passing `UITableViewScrollPositionNone` results in no scrolling, rather than the minimum scrolling described for that constant.
    /// To scroll to the newly selected row with minimum scrolling, select the row using this method with `UITableViewScrollPositionNone`,
    /// then call `scrollToRowAtIndexPath:atScrollPosition:animated:` with `UITableViewScrollPositionNone`.
    ///
    /// - Parameters:
    ///   - indexPaths:     An array of index paths identifying rows in the table view.
    ///   - animated:       Pass `true` if you want to animate the selection and any change in position;
    ///                     Pass `false` if the change should be immediate.
    ///   - scrollPosition: A constant that identifies a relative position in the table view (top, middle, bottom)
    ///                     for the row when scrolling concludes. The default value is `UITableViewScrollPositionNone`.
    public func selectRows(at indexPaths: [IndexPath], animated: Bool, scrollPosition: ScrollPosition = .none) {
        indexPaths.forEach {
            selectRow(at: $0, animated: animated, scrollPosition: scrollPosition)
        }
    }

    /// Deselects all selected rows, with an option to animate the deselection.
    ///
    /// Calling this method does not cause the delegate to receive a `tableView:willDeselectRowAtIndexPath:`
    /// or `tableView:didDeselectRowAtIndexPath:` message, nor does it send `UITableViewSelectionDidChangeNotification`
    /// notifications to observers.
    ///
    /// - Parameter animated: true if you want to animate the deselection, and false if the change should be immediate.
    public func deselectAllRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach {
            deselectRow(at: $0, animated: animated)
        }
    }

    /// Toggles the table view into and out of editing mode with completion handler when animation is completed.
    ///
    /// - Parameters:
    ///   - editing:           `true` to enter editing mode; `false` to leave it. The default value is `false`.
    ///   - animated:          `true` to animate the transition to editing mode; `false` to make the transition immediate.
    ///   - completionHandler: A block object called when animation is completed.
    public func setEditing(_ editing: Bool, animated: Bool, completionHandler: @escaping () -> Void) {
        CATransaction.animationTransaction({
            setEditing(editing, animated: animated)
        }, completionHandler: completionHandler)
    }
}

extension UITableView {
    /// Adjust target offset so that cells are snapped to top.
    ///
    /// Call this method in scroll view delegate:
    ///```swift
    /// func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    ///     snapRowsToTop(targetContentOffset, cellHeight: cellHeight, headerHeight: headerHeight)
    /// }
    ///```
    public func snapRowsToTop(_ targetContentOffset: UnsafeMutablePointer<CGPoint>, cellHeight: CGFloat, headerHeight: CGFloat) {
        // Adjust target offset so that cells are snapped to top
        let section = (indexPathsForVisibleRows?.first?.section ?? 0) + 1
        targetContentOffset.pointee.y -= (targetContentOffset.pointee.y.truncatingRemainder(dividingBy: cellHeight)) - (CGFloat(section) * headerHeight)
    }

    private func snapRowsToTop(_ targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // TODO: This can be use to handles a table view with varying row and section heights. Still needs testing
        // Find the indexPath where the animation will currently end.
        let indexPath = indexPathForRow(at: targetContentOffset.pointee) ?? IndexPath(row: 0, section: 0)

        var offsetY: CGFloat = 0
        for s in 0..<indexPath.section {
            for r in 0..<indexPath.row {
                let indexPath = IndexPath(row: r, section: s)
                var rowHeight = delegate?.tableView?(self, heightForRowAt: indexPath) ?? 0
                var sectionHeaderHeight = delegate?.tableView?(self, heightForHeaderInSection: s) ?? 0
                var sectionFooterHeight = delegate?.tableView?(self, heightForFooterInSection: s) ?? 0
                rowHeight = rowHeight == 0 ? self.rowHeight : rowHeight
                sectionFooterHeight = sectionFooterHeight == 0 ? self.sectionFooterHeight : sectionFooterHeight
                sectionHeaderHeight = sectionHeaderHeight == 0 ? self.sectionHeaderHeight : sectionHeaderHeight
                offsetY += rowHeight + sectionHeaderHeight + sectionFooterHeight
            }
        }

        // Tell the animation to end at the top of that row.
        targetContentOffset.pointee.y = offsetY
    }
}
