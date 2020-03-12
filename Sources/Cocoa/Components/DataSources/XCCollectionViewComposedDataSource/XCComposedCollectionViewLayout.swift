//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - XCComposedCollectionViewLayout

public struct XCComposedCollectionViewLayout {
    public let collectionViewLayout: XCComposedCollectionViewLayoutCompatible
    public let adapter: XCComposedCollectionViewLayoutAdapter

    public init(
        _ layout: XCComposedCollectionViewLayoutCompatible,
        adapter: XCComposedCollectionViewLayoutAdapter? = nil
    ) {
        self.collectionViewLayout = layout
        self.adapter = adapter ?? type(of: layout).defaultAdapterType.self.init()
    }
}

// MARK: - XCComposedCollectionViewLayoutCompatible

public protocol XCComposedCollectionViewLayoutCompatible: UICollectionViewLayout {
    static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type { get }
}
