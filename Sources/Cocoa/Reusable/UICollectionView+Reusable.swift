//
// UICollectionView+Reusable.swift
//
// Copyright © 2017 Zeeshan Mian
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

extension UICollectionView {
    private struct AssociatedKey {
        static var registeredCells = "registeredCells"
        static var registeredSupplementaryViews = "registeredSupplementaryViews"
    }

    private var registeredCells: Set<String> {
        get { return associatedObject(&AssociatedKey.registeredCells, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredCells, value: newValue) }
    }

    private var registeredSupplementaryViews: Set<String> {
        get { return associatedObject(&AssociatedKey.registeredSupplementaryViews, default: Set<String>()) }
        set { setAssociatedObject(&AssociatedKey.registeredSupplementaryViews, value: newValue) }
    }

    private func register<T: UICollectionViewCell>(_ cell: T.Type) {
        guard let nib = UINib(named: String(describing: cell), bundle: Bundle(for: T.self)) else {
            register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    private func registerSupplementaryView<T: UICollectionReusableView>(kind: SupplementaryViewKind, view: T.Type) {
        guard let nib = UINib(named: String(describing: view), bundle: Bundle(for: T.self)) else {
            register(view, forSupplementaryViewOfKind: kind.identifier, withReuseIdentifier: T.reuseIdentifier)
            return
        }

        register(nib, forSupplementaryViewOfKind: kind.identifier, withReuseIdentifier: T.reuseIdentifier)
    }

    private func registerIfNeeded<T: UICollectionViewCell>(_ cell: T.Type) {
        guard !registeredCells.contains(T.reuseIdentifier) else { return }
        registeredCells.insert(T.reuseIdentifier)
        register(cell)
    }

    private func registerSupplementaryViewIfNeeded<T: UICollectionReusableView>(kind: SupplementaryViewKind, view: T.Type) {
        guard !registeredSupplementaryViews.contains(T.reuseIdentifier) else { return }
        registeredSupplementaryViews.insert(T.reuseIdentifier)
        registerSupplementaryView(kind: kind, view: view)
    }
}

extension UICollectionView {
    public enum SupplementaryViewKind {
        case header
        case footer
        case custom(String)

        public var identifier: String {
            switch self {
                case .header:
                    return UICollectionElementKindSectionHeader
                case .footer:
                    return UICollectionElementKindSectionFooter
                case .custom(let type):
                    return type
            }
        }
    }

    /// Returns a reusable `UICollectionReusableView` instance for the class inferred by the return type.
    ///
    /// - Parameters:
    ///   - kind:      The kind of supplementary view to locate.
    ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
    /// - Returns: The specified supplementary view or nil if the view could not be found.
    public func supplementaryView<T: UICollectionReusableView>(kind: SupplementaryViewKind, at indexPath: IndexPath) -> T? {
        return supplementaryView(forElementKind: kind.identifier, at: indexPath) as? T
    }

    /// Returns a reusable `UICollectionReusableView` instance for the class inferred by the return type.
    ///
    /// - Parameters:
    ///   - kind:      The kind of supplementary view to retrieve.
    ///   - indexPath: The index path specifying the location of the supplementary view in the collection view.
    /// - Returns: A reusable `UICollectionReusableView` instance.
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(kind: SupplementaryViewKind, for indexPath: IndexPath) -> T {
        registerSupplementaryViewIfNeeded(kind: kind, view: T.self)

        guard let view = dequeueReusableSupplementaryView(ofKind: kind.identifier, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(because: .dequeueFailed(for: "UICollectionReusableView", identifier: T.reuseIdentifier))
        }

        return view
    }

    /// Returns a reusable `UICollectionViewCell` instance for the class inferred by the return type.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell in the collection view.
    /// - Returns: A reusable `UICollectionViewCell` instance.
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        registerIfNeeded(T.self)

        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(because: .dequeueFailed(for: "UICollectionViewCell", identifier: T.reuseIdentifier))
        }

        return cell
    }
}
