//
// AppState.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public struct AppState {
    public typealias Identifier = Xcore.Identifier<Self>

    /// A unique id for the app state.
    public let id: Identifier

    /// A boolean property indicating whether this state is remotely refreshable
    /// (e.g., **RemoteConfig**).
    ///
    /// The default value is `false`.
    public let isRemotelyRefreshable: Bool

    /// The view controller associate with this state.
    public var viewController: () -> UIViewController

    /// The condition indicating if the state is valid. If so, then corresponding
    /// view controller will be presented.
    public var precondition: () -> Bool

    public init(
        id: Identifier,
        remotelyRefreshable: Bool = false,
        viewController: @autoclosure @escaping () -> UIViewController,
        precondition: @escaping () -> Bool
    ) {
        self.id = id
        self.isRemotelyRefreshable = remotelyRefreshable
        self.viewController = viewController
        self.precondition = precondition
    }
}

// MARK: - Hashable

extension AppState: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Equatable

extension AppState: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
