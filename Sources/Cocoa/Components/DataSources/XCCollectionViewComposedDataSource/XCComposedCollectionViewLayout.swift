//
//  XCComposedCollectionViewLayout.swift
//  Xcore
//
//  Created by Guillermo Waitzel on 29/05/2019.
//

import Foundation

public struct XCComposedCollectionViewLayout {    
    public let collectionViewLayout: XCComposedCollectionViewLayoutCompatible
    public let adapter: XCComposedCollectionViewLayoutAdapter

    public init(_ layout: XCComposedCollectionViewLayoutCompatible, adapter: XCComposedCollectionViewLayoutAdapter? = nil) {
        collectionViewLayout = layout
        self.adapter = adapter ?? type(of: layout).defaultAdapterType.self.init()
    }
}

public protocol XCComposedCollectionViewLayoutCompatible: UICollectionViewLayout {
    static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type { get }
}
