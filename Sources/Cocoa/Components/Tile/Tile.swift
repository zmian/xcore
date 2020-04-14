//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct Tile: UserInfoContainer, MutableAppliable, CustomAnalyticsValueConvertible {
    public typealias Identifier = Xcore.Identifier<Self>

    /// A unique id for the tile.
    public let id: Identifier

    /// A boolean property indicating whether this tile is dismissable.
    ///
    /// The default value is `false`.
    public let isDismissable: Bool

    /// The analytics value for the tile.
    public let analyticsValue: String

    /// The accessibility label for the tile.
    public let accessibilityLabel: String

    /// The data source associated with this tile.
    public let dataSource: (_ collectionView: UICollectionView) -> XCCollectionViewDataSource

    /// Additional info which may be used to describe the url further.
    public var userInfo: UserInfo

    public init(
        id: Identifier,
        dismissable: Bool = false,
        analyticsValue: String? = nil,
        accessibilityLabel: String? = nil,
        dataSource: @escaping (_ collectionView: UICollectionView) -> XCCollectionViewDataSource,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.isDismissable = dismissable
        self.analyticsValue = analyticsValue ?? id.rawValue.snakecased()
        self.accessibilityLabel = accessibilityLabel ?? id.rawValue.titlecased() + " Tile"
        self.dataSource = dataSource
        self.userInfo = userInfo
    }
}

// MARK: - Hashable

extension Tile: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension Tile: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
