//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct Frequency: UserInfoContainer, MutableAppliable, CustomAnalyticsValueConvertible, PickerOptions {
    public typealias Identifier = Xcore.Identifier<Self>

    /// A unique id for the frequency.
    public let id: Identifier

    /// The title for the frequency.
    public let title: String

    /// The analytics value for the frequency.
    public let analyticsValue: String

    /// The data interval associated with this frequency.
    public let dateInterval: DateInterval

    /// Additional info which may be used to describe the frequency further.
    public var userInfo: UserInfo

    public init(
        id: Identifier = #function,
        title: String,
        analyticsValue: String? = nil,
        dateInterval: DateInterval,
        userInfo: UserInfo = [:]
    ) {
        self.id = id
        self.title = title
        self.analyticsValue = analyticsValue ?? id.rawValue.snakecased()
        self.dateInterval = dateInterval
        self.userInfo = userInfo
    }
}

// MARK: - CustomStringConvertible

extension Frequency: CustomStringConvertible {
    public var description: String {
        title
    }
}

// MARK: - Hashable

extension Frequency: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension Frequency: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
