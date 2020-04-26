//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(PromiseKit)
import PromiseKit

extension Date {
    /// A type that enables an easy way to sync remote dates.
    ///
    /// # Usage
    /// ```swift
    /// enum RemoteDates {
    ///     static let remoteServer1Date = Date.Remote(expirationDuration: 3600) {
    ///         .value(Date())
    ///     }
    ///
    ///     static let remoteServer2Date = Date.Remote(expirationDuration: 3600) {
    ///         .value(Date())
    ///     }
    /// }
    /// ```
    public class Remote {
        private let expirationDuration: TimeInterval
        private var lastTimestamp: CFAbsoluteTime?
        private let dateProvider: () -> Promise<Date>
        private let defaultDate: () -> Date
        private var fetchedDate: Date?

        public init(
            expirationDuration: TimeInterval,
            default defaultValue: @autoclosure @escaping () -> Date = Date(),
            provider: @escaping () -> Promise<Date>
        ) {
            self.expirationDuration = expirationDuration
            self.defaultDate = defaultValue
            self.dateProvider = provider
        }

        public var date: Date {
            fetchedDate ?? defaultDate()
        }

        private func update(date: Date?) {
            fetchedDate = date
            lastTimestamp = CFAbsoluteTimeGetCurrent()
        }

        public var isExpired: Bool {
            guard let lastTimestamp = lastTimestamp else {
                return true
            }

            let distance = lastTimestamp.distance(to: CFAbsoluteTimeGetCurrent())
            return distance < 0 || distance > expirationDuration
        }

        @discardableResult
        public func sync(force: Bool = false) -> Promise<Date> {
            let avoidCache = force || isExpired

            guard avoidCache else {
                return .value(date)
            }

            return .init { seal in
                firstly {
                    dateProvider()
                }.done { [weak self] date in
                    self?.update(date: date)
                    seal.fulfill(date)
                }.catch { error in
                    seal.reject(error)
                }
            }
        }
    }
}
#endif
