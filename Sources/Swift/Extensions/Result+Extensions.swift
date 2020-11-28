//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Result where Success == Void {
    /// A success, storing a `Success` value.
    public static var success: Self {
        .success(())
    }
}
