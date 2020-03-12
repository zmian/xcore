//
// CollectionViewDequeueCache.swift
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
        dequeueCell(identifier: Cell.reuseIdentifier) as! Cell
    }

    public func dequeueSupplementaryView<View>(kind: UICollectionView.SupplementaryViewKind) -> View where View: UICollectionReusableView {
        dequeueSupplementaryView(kind: kind.rawValue, identifier: View.reuseIdentifier) as! View
    }

    /// Empties the cache.
    public func removeAll() {
        cellCache.removeAll(keepingCapacity: false)
        supplementaryViewCache.removeAll(keepingCapacity: false)
    }
}
