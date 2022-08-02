//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Bool {
    public init?(_ optionalString: String?) {
        guard
            let valueString = optionalString,
            let value = Bool(valueString)
        else {
            return nil
        }

        self = value
    }

    /// Returns "on" or "off" representation of `self`.
    public var onOffValue: String {
        self ? "on" : "off"
    }
}
