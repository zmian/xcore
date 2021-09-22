//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Samples {
    /// Strings used for debug and previews purpose.
    public enum Strings {
        public typealias Alert = (title: String, message: String)

        public static let locationAlert = Alert(
            title: "Current Location Not Available",
            message: "Your current location can’t be determined at this time."
        )

        public static let deleteMessageAlert = Alert(
            title: "Delete Message",
            message: "Are you sure you want to delete this message?"
        )
    }
}
