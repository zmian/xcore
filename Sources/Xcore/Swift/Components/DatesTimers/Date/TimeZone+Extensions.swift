//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension TimeZone {
    /// Returns the `UTC` time zone.
    public static let utc = TimeZone(identifier: "UTC")!

    /// Returns the `America/New_York` time zone.
    public static let eastern = TimeZone(identifier: "America/New_York")!

    /// Returns the `Europe/Istanbul` time zone.
    public static let istanbul = TimeZone(identifier: "Europe/Istanbul")!

    /// Returns the `Europe/London` time zone.
    public static let london = TimeZone(identifier: "Europe/London")!
}
