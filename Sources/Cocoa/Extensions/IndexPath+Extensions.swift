//
// IndexPath+Extensions.swift
//
// Copyright © 2017 Xcore
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

extension IndexPath {
    public static var zero: IndexPath {
        return IndexPath(item: 0, section: 0)
    }

    public func with(_ globalSection: Int) -> IndexPath {
        return IndexPath(row: row, section: globalSection + section)
    }
}

extension IndexPath {
    public func previous() -> IndexPath? {
        guard item > 0 else {
            return nil
        }

        return IndexPath(row: item - 1, section: section)
    }

    public func next(in collectionView: UICollectionView) -> IndexPath? {
        let itemsInSection = collectionView.numberOfItems(inSection: section)

        guard item + 1 < itemsInSection else {
            return nil
        }

        return IndexPath(row: item + 1, section: section)
    }

    public func next(in tableView: UITableView) -> IndexPath? {
        let rowsInSection = tableView.numberOfRows(inSection: section)

        guard row + 1 < rowsInSection else {
            return nil
        }

        return IndexPath(row: row + 1, section: section)
    }
}
