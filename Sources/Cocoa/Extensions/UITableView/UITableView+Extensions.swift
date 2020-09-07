//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITableView {
    /// Compares the top two visible rows to the current content offset and returns
    /// the best index path that is visible on the top.
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
    /// This simply return empty array when there are no selected rows instead of
    /// `nil`.
    ///
    /// ```swift
    /// return indexPathsForSelectedRows ?? []
    /// ```
    public var selectedIndexPaths: [IndexPath] {
        indexPathsForSelectedRows ?? []
    }

    /// The total number of rows in all the sections.
    public var numberOfRowsInAllSections: Int {
        var rows = 0
        for i in 0..<numberOfSections {
            rows += numberOfRows(inSection: i)
        }
        return rows
    }

    /// Selects a row in the table view identified by index path, optionally
    /// scrolling the row to a location in the table view.
    ///
    /// Calling this method does not cause the delegate to receive a
    /// `tableView:willSelectRowAtIndexPath:` or
    /// `tableView:didSelectRowAtIndexPath:` message, nor does it send
    /// `UITableViewSelectionDidChangeNotification` notifications to observers.
    ///
    /// Passing `UITableViewScrollPosition.none` results in no scrolling, rather
    /// than the minimum scrolling described for that constant. To scroll to the
    /// newly selected row with minimum scrolling, select the row using this method
    /// with `UITableViewScrollPosition.none`, then call
    /// `scrollToRowAtIndexPath:atScrollPosition:animated:` with
    /// `UITableViewScrollPosition.none`.
    ///
    /// - Parameters:
    ///   - indexPaths: An array of index paths identifying rows in the table view.
    ///   - animated: Pass `true` if you want to animate the selection and any
    ///               change in position; Pass `false` if the change should be
    ///               immediate.
    ///   - scrollPosition: A constant that identifies a relative position in the
    ///                     table view (top, middle, bottom) for the row when
    ///                     scrolling concludes. The default value is `.none`.
    public func selectRows(
        at indexPaths: [IndexPath],
        animated: Bool,
        scrollPosition: ScrollPosition = .none
    ) {
        indexPaths.forEach {
            selectRow(at: $0, animated: animated, scrollPosition: scrollPosition)
        }
    }

    /// Deselects all selected rows, with an option to animate the deselection.
    ///
    /// Calling this method does not cause the delegate to receive a
    /// `tableView:willDeselectRowAtIndexPath:` or
    /// `tableView:didDeselectRowAtIndexPath:` message, nor does it send
    /// `UITableViewSelectionDidChangeNotification` notifications to observers.
    ///
    /// - Parameter animated: `true` if you want to animate the deselection, and
    ///                       `false` if the change should be immediate.
    public func deselectAllRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach {
            deselectRow(at: $0, animated: animated)
        }
    }
}
