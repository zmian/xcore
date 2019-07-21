//
// UserDefaultsAnalyticsProvider.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

/// An analytics provider that can be used for unit tests.
final public class UserDefaultsAnalyticsProvider: AnalyticsProvider {
    private let suiteName: String
    private lazy var userDefaults = UserDefaults(suiteName: suiteName)!

    /// Creates an analytics provider object with the specified database name.
    ///
    /// - Parameter named: The database name. Specifying `nil` defaults to database
    ///                    named: `UserDefaultsAnalyticsProvider`.
    public init(named: String? = nil) {
        self.suiteName = named ?? name(of: UserDefaultsAnalyticsProvider.self)
    }

    public func track(_ event: AnalyticsEvent) {
        let properties = event.properties ?? [:]
        userDefaults.set(properties, forKey: event.name)
    }

    public func contains(_ eventName: String) -> Bool {
        return userDefaults.object(forKey: eventName) != nil
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

    public func removeAll() {
        userDefaults.removePersistentDomain(forName: suiteName)
    }
}
