//
// CollectionViewDequeueCache.swift
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

final public class CollectionViewDequeueCache {
    private var notificationToken: NSObjectProtocol?
    private var cellCache: [String: UICollectionViewCell] = [:]
    private var supplementaryViewCache: [String: UICollectionReusableView] = [:]

    public static let shared = CollectionViewDequeueCache()

    private init() {
        setupApplicationMemoryWarningObserver()
    }

    private func setupApplicationMemoryWarningObserver() {
        notificationToken = NotificationCenter.on.applicationDidReceiveMemoryWarning { [weak self] in
            self?.removeAll()
        }
    }

    deinit {
        NotificationCenter.remove(notificationToken)
    }

    func dequeueCell(identifier: String) -> UICollectionViewCell {
        let className = identifier

        if let cachedCell = cellCache[className] {
            cachedCell.prepareForReuse()
            return cachedCell
        }

        let aClass = NSClassFromString(className) as! UICollectionViewCell.Type
        let cell = aClass.init(frame: .zero)
        cellCache[className] = cell
        return cell
    }

    func dequeueSupplementaryView(kind elementKind: String, identifier: String) -> UICollectionReusableView {
        let className = identifier
        let key = className + elementKind

        if let cachedSupplementaryView = supplementaryViewCache[key] {
            cachedSupplementaryView.prepareForReuse()
            return cachedSupplementaryView
        }

        let aClass = NSClassFromString(className) as! UICollectionReusableView.Type
        let supplementaryView = aClass.init(frame: .zero)
        supplementaryViewCache[key] = supplementaryView
        return supplementaryView
    }
}

// MARK: - API

extension CollectionViewDequeueCache {
    /// Creates and cache `UICollectionViewCell` (subclass determined at runtime
    /// using the cell's reuse identifier);
    ///
    /// Used to compute size of `UICollectionViewCell` at a given index path.
    public func dequeueCell<Cell>() -> Cell where Cell: UICollectionViewCell {
        return dequeueCell(identifier: Cell.reuseIdentifier) as! Cell
    }

    public func dequeueSupplementaryView<View>(kind: UICollectionView.SupplementaryViewKind) -> View where View: UICollectionReusableView {
        return dequeueSupplementaryView(kind: kind.rawValue, identifier: View.reuseIdentifier) as! View
    }

    /// Empties the cache.
    public func removeAll() {
        cellCache.removeAll(keepingCapacity: false)
        supplementaryViewCache.removeAll(keepingCapacity: false)
    }
}
