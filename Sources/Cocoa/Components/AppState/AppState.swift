//
// AppState.swift
//
// Copyright © 2018 Xcore
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
