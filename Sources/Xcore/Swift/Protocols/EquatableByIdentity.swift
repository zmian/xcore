//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

/// A protocol that auto-implements `Equatable` by using class instance
/// identity.
public protocol EquatableByIdentity: AnyObject, Equatable {}

extension EquatableByIdentity {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
