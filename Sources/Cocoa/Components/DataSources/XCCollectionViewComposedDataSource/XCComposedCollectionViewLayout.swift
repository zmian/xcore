//
//  XCComposedCollectionViewLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 29/05/2019.
//

import Foundation

public struct XCComposedCollectionViewLayout {
    public let collectionViewLayout: XCComposedCollectionViewLayoutCompatible
    public let delegate: XCComposedCollectionViewLayoutAdapter

    public init(_ layout: XCComposedCollectionViewLayoutCompatible, delegate: XCComposedCollectionViewLayoutAdapter? = nil) {
        collectionViewLayout = layout
        self.delegate = delegate ?? type(of: layout).defaultAdapterType.self.init()
    }
}

public protocol XCComposedCollectionViewLayoutCompatible: UICollectionViewLayout {
    static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type { get }
}
