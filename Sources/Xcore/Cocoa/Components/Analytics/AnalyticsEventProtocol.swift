//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol AnalyticsEventProtocol {
    /// The name of the event that is sent to analytics providers.
    var name: String { get }

    /// The properties of the event that is sent to analytics providers.
    var properties: [String: Any] { get }

    /// An option to send this event to additional analytics providers.
    ///
    /// For example, if a specific event should be tracked in Firebase, then, the
    /// said event can return `Firebase` analytics provider as the additional
    /// provider.
    var additionalProviders: [AnalyticsProvider] { get }
}
