//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension DateInterval {
    /// Returns the middle Date of a DateInterval
    ///
    /// Due to timezone and daylight savings constraints, relying on either
    /// `.start` or `.end` of a DateInterval - when the goal is to group days -
    /// might produce unexpected results as they can return the previous or next
    /// day respectively.
    ///
    /// With `.middle` we can be sure we'll always land on the correct day.
    var middle: Date {
        start + (duration / 2)
    }
}
