//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An analytics provider that can be used for unit tests.
public final class UserDefaultsAnalyticsProvider: AnalyticsProvider {
    private let suiteName: String
    private lazy var userDefaults = UserDefaults(suiteName: suiteName)!
    private var isEnabled = true

    /// Creates an analytics provider object with the specified database name.
    ///
    /// - Parameter named: The database name. Specifying `nil` defaults to database
    ///   named: `UserDefaultsAnalyticsProvider`.
    public init(named: String? = nil) {
        self.suiteName = named ?? name(of: UserDefaultsAnalyticsProvider.self)
    }

    public func track(_ event: AnalyticsEventProtocol) {
        guard isEnabled else {
            return
        }

        userDefaults.set(event.properties, forKey: event.name)
    }

    public func contains(_ eventName: String) -> Bool {
        userDefaults.object(forKey: eventName) != nil
    }

    public func properties(for eventName: String) -> [String: Any]? {
        guard let result = userDefaults.dictionary(forKey: eventName) else {
            return nil
        }

        return result.isEmpty ? nil : result
    }

    public func remove(_ eventName: String) {
        userDefaults.removeObject(forKey: eventName)
    }

    public func setEnabled(_ enable: Bool) {
        isEnabled = enable
    }

    /// Removes all of the events.
    public func reset() {
        userDefaults.removePersistentDomain(forName: suiteName)
    }
}
