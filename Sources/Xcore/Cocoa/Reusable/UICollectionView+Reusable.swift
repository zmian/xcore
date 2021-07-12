//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UICollectionView {
    private enum AssociatedKey {
        static var registeredCells = "registeredCells"
        static var registeredSupplementaryViews = "registeredSupplementaryViews"
    }

    private var registeredCells: Set<String> {
        get { associatedObject(&AssociatedKey.registeredCells, default: []) }
        set { setAssociatedObject(&AssociatedKey.registeredCells, value: newValue) }
    }

    private var registeredSupplementaryViews: Set<String> {
        get { associatedObject(&AssociatedKey.registeredSupplementaryViews, default: []) }
        set { setAssociatedObject(&AssociatedKey.registeredSupplementaryViews, value: newValue) }
    }

    private func register<T: UICollectionViewCell>(_ cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    private func registerSupplementaryView<T: UICollectionReusableView>(kind: SupplementaryViewKind, view: T.Type) {
        register(view, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier)
    }

    private func registerIfNeeded<T: UICollectionViewCell>(_ cell: T.Type) {
        guard !registeredCells.contains(T.reuseIdentifier) else { return }
        registeredCells.insert(T.reuseIdentifier)
        register(cell)
    }

    private func registerSupplementaryViewIfNeeded<T: UICollectionReusableView>(kind: SupplementaryViewKind, view: T.Type) {
        let identifier = kind.rawValue + T.reuseIdentifier
        guard !registeredSupplementaryViews.contains(identifier) else { return }
        registeredSupplementaryViews.insert(identifier)
        registerSupplementaryView(kind: kind, view: view)
    }
}

extension UICollectionView {
    public struct SupplementaryViewKind: RawRepresentable, Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }

        public var description: String {
            rawValue
        }

        // swiftlint:disable inc_header_view inc_footer_view
        public static let header = Self(rawValue: UICollectionView.elementKindSectionHeader)
        public static let footer = Self(rawValue: UICollectionView.elementKindSectionFooter)
        // swiftlint:enable inc_header_view inc_footer_view
    }
}

extension UICollectionView {
    /// Returns whether the given index path is valid for the current layout
    /// information.
    open func isValid(indexPath: IndexPath) -> Bool {
        indexPath.section < numberOfSections && indexPath.row < numberOfItems(inSection: indexPath.section)
    }

    /// Returns the layout information for the specified supplementary view.
    ///
    /// Use this method to retrieve the layout information for a particular
    /// supplementary view. You should always use this method instead of querying
    /// the layout object directly.
    ///
    /// - Parameters:
    ///   - kind: A string specifying the kind of supplementary view whose layout
    ///     attributes you want. Layout classes are responsible for defining the
    ///     kinds of supplementary views they support.
    ///   - indexPath: The index path of the supplementary view. The interpretation
    ///     of this value depends on how the layout implements the view. For
    ///     example, a view associated with a section might contain just a section
    ///     value.
    /// - Returns: The layout attributes of the supplementary view or `nil` if the
    ///   specified supplementary view does not exist.
    open func layoutAttributesForSupplementaryElement(
        ofKind kind: SupplementaryViewKind,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        guard isValid(indexPath: indexPath) else {
            return nil
        }

        return layoutAttributesForSupplementaryElement(ofKind: kind.rawValue, at: indexPath)
    }

    /// Returns a reusable `UICollectionReusableView` instance for the class
    /// inferred by the return type.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view to locate.
    ///   - indexPath: The index path specifying the location of the supplementary
    ///     view in the collection view.
    /// - Returns: The specified supplementary view or `nil` if the view could not
    ///   be found.
    open func supplementaryView<T: UICollectionReusableView>(
        _ kind: SupplementaryViewKind,
        at indexPath: IndexPath
    ) -> T? {
        supplementaryView(forElementKind: kind.rawValue, at: indexPath) as? T
    }

    /// Returns a reusable `UICollectionReusableView` instance for the class
    /// inferred by the return type.
    ///
    /// - Parameters:
    ///   - kind: The kind of supplementary view to retrieve.
    ///   - indexPath: The index path specifying the location of the supplementary
    ///     view in the collection view.
    /// - Returns: A reusable `UICollectionReusableView` instance.
    open func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        _ kind: SupplementaryViewKind,
        for indexPath: IndexPath
    ) -> T {
        registerSupplementaryViewIfNeeded(kind: kind, view: T.self)

        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind.rawValue,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError(because: .dequeueFailed(for: "UICollectionReusableView", identifier: T.reuseIdentifier))
        }

        return view
    }

    /// Returns a reusable `UICollectionViewCell` instance for the class inferred by
    /// the return type.
    ///
    /// - Parameter indexPath: The index path specifying the location of the cell in
    ///   the collection view.
    /// - Returns: A reusable `UICollectionViewCell` instance.
    open func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        registerIfNeeded(T.self)

        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError(because: .dequeueFailed(for: "UICollectionViewCell", identifier: T.reuseIdentifier))
        }

        return cell
    }
}

extension UICollectionViewLayout {
    /// A convenience method to return the layout attributes for the specified
    /// supplementary view.
    ///
    /// - Parameters:
    ///   - kind: A string that identifies the type of the supplementary view.
    ///   - indexPath: The index path of the view.
    /// - Returns: A layout attributes object containing the information to apply to
    ///   the supplementary view.
    public func layoutAttributesForSupplementaryView(
        ofKind kind: UICollectionView.SupplementaryViewKind,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        layoutAttributesForSupplementaryView(ofKind: kind.rawValue, at: indexPath)
    }
}
