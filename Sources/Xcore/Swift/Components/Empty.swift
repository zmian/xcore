//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import SwiftUI

/// A structure representing empty value.
@frozen
public struct Empty {
    public init() {}
}

extension Empty: Sendable {}
extension Empty: Equatable, Hashable {}
extension Empty: Codable {}

extension Empty: Identifiable {
    public var id: String { "" }
}

extension Empty: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        false
    }

    public static func >(lhs: Self, rhs: Self) -> Bool {
        false
    }
}

extension Empty: View {
    public var body: some View {
        EmptyView()
    }
}
