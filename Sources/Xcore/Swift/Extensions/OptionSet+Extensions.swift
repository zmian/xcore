//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension OptionSet {
    /// Returns a Boolean value that indicates whether the set has any members in
    /// common with the given set.
    ///
    /// - Parameter member: A set of the same type as the current set.
    /// - Returns: `true` if the set has any elements in common with other;
    ///   otherwise, `false`.
    /// - SeeAlso: `isDisjoint(with:)`
    public func contains(any member: Self) -> Bool {
        !isDisjoint(with: member)
    }

    /// Returns an empty set `[]`.
    public static var none: Self { [] }
}
