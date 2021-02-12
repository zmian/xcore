//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Binding {
    /// `get` only binding with `noop` for setter.
    public static func get(_ block: @autoclosure @escaping () -> Value) -> Self {
        .init(get: block, set: { _ in })
    }
}
