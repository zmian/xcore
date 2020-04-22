//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import PromiseKit

// MARK: - Configuration

extension Date {
    public private(set) static var configuration: Configuration = .init()

    public static func configure(_ configuration: Configuration) {
        Self.configuration = configuration
        NotificationCenter.on.applicationDidBecomeActive {
            Self.syncServerDate()
        }
    }
}

extension Date.Region {
    public static var `default`: Self {
        Date.configuration.region
    }
}

extension Date {
    public struct Configuration {
        public let region: Region
        public let serverDateProvider: Promise<Date>
        public let serverDateExpirationTime: TimeInterval

        public init(
            region: Region = .iso,
            serverDateProvider: Promise<Date> = .value(Date()),
            serverDateExpirationTime: TimeInterval = 3600
        ) {
            self.region = region
            self.serverDateProvider = serverDateProvider
            self.serverDateExpirationTime = serverDateExpirationTime
        }
    }
}

// MARK: - Server Date

extension Date {
    public static var serverDate: Date {
        storedServerDate ?? Date()
    }

    private static var storedServerDate: Date?
    private static var lastServerDateTimestamp: CFAbsoluteTime?

    public static var isServerDateExpired: Bool {
        guard let lastServerDateTimestamp = lastServerDateTimestamp else { return true }
        let distance = lastServerDateTimestamp.distance(to: CFAbsoluteTimeGetCurrent())
        return distance < 0 || distance > configuration.serverDateExpirationTime
    }

    @discardableResult
    public static func syncServerDate(force: Bool = false) -> Promise<Date> {
        let avoidCache = force || isServerDateExpired

        guard avoidCache else {
            return .value(serverDate)
        }

        return .init { seal in
            firstly {
                configuration.serverDateProvider
            }.done { date in
                storedServerDate = date
                lastServerDateTimestamp = CFAbsoluteTimeGetCurrent()
                seal.fulfill(date)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
}
