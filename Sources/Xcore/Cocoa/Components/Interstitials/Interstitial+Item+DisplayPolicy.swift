//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Interstitial.Item {
    /// A struct to check any necessary condition before presenting the interstitial
    /// item.
    public struct DisplayPolicy {
        /// A boolean property indicating whether interstitial item is dismissable.
        public let isDismissable: Bool

        /// An optional property to specify delay interval before this interstitial item
        /// is displayed again.
        public let replayDelay: TimeInterval?

        /// This method is invoked before this interstitial item is presented.
        public let precondition: () -> Bool

        public init(
            dismissable: Bool = false,
            replayDelay: TimeInterval? = nil,
            precondition: @escaping () -> Bool
        ) {
            self.isDismissable = dismissable
            self.replayDelay = replayDelay
            self.precondition = precondition
        }

        public static func precondition(_ condition: @escaping () -> Bool) -> Self {
            .init(precondition: condition)
        }

        public static var never: Self {
            .init(precondition: { false })
        }

        public static var always: Self {
            always(dismissable: false)
        }

        public static func always(dismissable: Bool) -> Self {
            .init(dismissable: dismissable, precondition: { true })
        }
    }
}
