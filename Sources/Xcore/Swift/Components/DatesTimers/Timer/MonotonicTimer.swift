//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// A monotonic timer is a time source that won't ever jump forward or backward
/// (due to NTP or Daylight Savings Time updates).
public enum MonotonicTimer {}

// MARK: - Uptime

extension MonotonicTimer {
    public final class Uptime: Equatable {
        public let id: UUID
        private lazy var begin = DispatchTime.now().uptimeNanoseconds

        public init() {
            #if DEBUG
            // For tests we want to control the uuid value to make sure equatable is
            // predictable.
            if ProcessInfo.Arguments.isTesting {
                self.id = .zero
                return
            }
            #endif

            self.id = UUID()
        }

        /// Save the current uptime value internally.
        public func saveValue() {
            begin = DispatchTime.now().uptimeNanoseconds
        }

        public func elapsed(_ duration: TimeInterval) -> Bool {
            let diff = diffInSeconds

            // System was restarted.
            if diff < 0 {
                return true
            }

            return diff >= duration
        }

        public func secondsElapsed() -> Int {
            let diff = lround(diffInSeconds)

            // System was restarted.
            if diff < 0 {
                return 0
            }

            return diff
        }

        private var diffInSeconds: TimeInterval {
            DispatchTime.seconds(elapsedSince: begin)
        }

        public static func == (lhs: Uptime, rhs: Uptime) -> Bool {
            lhs.id == rhs.id
        }
    }
}
