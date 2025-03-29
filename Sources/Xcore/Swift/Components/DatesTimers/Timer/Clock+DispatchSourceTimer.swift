//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A custom `Clock` that uses `DispatchSourceTimer` for sleeping.
///
/// This can be used to ensure sleeping continues to work correctly even when
/// background execution is required.
///
/// **Usage**
///
/// ```swift
/// let clock = DispatchSourceTimerClock()
/// try await clock.sleep(for: .seconds(1))
/// ```
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
struct DispatchSourceTimerClock: Clock {
    typealias Duration = Swift.Duration
    typealias Instant = ContinuousClock.Instant

    var now: Instant {
        ContinuousClock().now
    }

    var minimumResolution: Duration {
        .nanoseconds(1)
    }

    init() {}

    func sleep(until deadline: Instant, tolerance: Duration? = nil) async throws {
        nonisolated(unsafe) let timer = DispatchSource.makeTimerSource(queue: .global(qos: .default))

        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                if Task.isCancelled {
                    timer.cancel()
                    continuation.resume(throwing: CancellationError())
                    return
                }

                timer.schedule(
                    deadline: .now() + now.duration(to: deadline).seconds,
                    repeating: .never,
                    leeway: .nanoseconds(Int(tolerance?.nanoseconds ?? 0))
                )

                timer.setEventHandler { [weak timer] in
                    timer?.cancel()
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        continuation.resume()
                    }
                }

                timer.activate()

                if Task.isCancelled {
                    timer.cancel()
                    continuation.resume(throwing: CancellationError())
                }
            }
        } onCancel: {
            timer.cancel()
        }
    }
}

// MARK: - Dot Syntax Support

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
extension Clock where Self == DispatchSourceTimerClock {
    /// A custom `Clock` that uses `DispatchSourceTimer` for sleeping.
    ///
    /// This can be used to ensure sleeping continues to work correctly even when
    /// background execution is required.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// try await Task.sleep(for: .seconds(1), clock: .dispatchSourceTimer)
    /// ```
    static var dispatchSourceTimer: Self {
        DispatchSourceTimerClock()
    }
}
