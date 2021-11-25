//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// Ideally, We can remove this type when Swift allows us to generalize a
// protocol with "associatedtype" requirement. For example:
//
// `typealias PreferencesKey = Identifiable where ID == String`
public protocol PreferencesClientKey {
    var id: String { get }
}

extension PreferencesClientKey where Self: Identifiable, ID == String {}

extension PreferencesClientKey where Self: RawRepresentable, RawValue == String {
    public var id: RawValue {
        rawValue
    }
}
