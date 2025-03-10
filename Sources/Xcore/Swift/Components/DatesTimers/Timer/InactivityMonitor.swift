//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// Monitors user inactivity and toggles the `isInactive` property after a specified
/// timeout period.
///
/// The `InactivityMonitor` observes user interaction through gesture
/// recognizers and app lifecycle events. It uses a monotonic clock to measure
/// elapsed time, ensuring accuracy even if the system clock changes (e.g., due
/// to NTP or daylight savings adjustments).
///
/// When inactivity is detected, the `isInactive` property is updated. This
/// property can be observed in SwiftUI to trigger actions such as displaying a
/// lock screen.
///
/// **Usage**
///
/// ```swift
/// @main
/// struct ExampleApp: App {
///     @State private var inactivityMonitor = InactivityMonitor(timeout: .minutes(5))
///
///     var body: some Scene {
///         WindowGroup {
///             ZStack {
///                 if inactivityMonitor.isInactive {
///                     Text("App Locked")
///                     // Once unlocked call:
///                     // "inactivityMonitor.reset()"
///                 } else {
///                     Text("Welcome to the App!")
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// - Note: The timer uses a monotonic time source to ensure it does not jump
///   forward or backward due to system clock changes.
@Observable
@MainActor
public final class InactivityMonitor {
    private var notificationToken: NSObjectProtocol?
    private var timer: DispatchSourceTimer?
    private var lastActivityTime: ElapsedTime
    /// The duration of inactivity after which the app is considered inactive.
    private let timeout: Duration

    /// Indicates whether the inactivity timeout has been reached.
    ///
    /// This property automatically notifies SwiftUI when its value changes.
    public private(set) var isInactive: Bool = false

    /// Creates an instance of `InactivityMonitor` with a specified timeout
    /// duration.
    ///
    /// - Parameter timeout: The duration after which inactivity is detected.
    public init(timeout: Duration = .minutes(5)) {
        self.timeout = timeout
        self.lastActivityTime = .init()

        addObservers()
        startTimer()
    }

    /// Configures observers to detect user activity.
    ///
    /// Observes app lifecycle events and attaches gesture recognizers to the app's
    /// main window for monitoring user interactions.
    private func addObservers() {
        // Observe app lifecycle events (e.g., app entering the foreground).
        notificationToken = NotificationCenter.observe(
            UIApplication.willEnterForegroundNotification
        ) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.checkInactivity()
            }
        }

        // Attach gesture recognizers to the main app window for detecting user touches.
        if let window = UIApplication.sharedOrNil?.firstSceneKeyWindow {
            let tapGesture = UITapGestureRecognizer { [weak self] _ in
                self?.onActivityDetected()
            }

            let panGesture = UIPanGestureRecognizer { [weak self] _ in
                self?.onActivityDetected()
            }

            // Ensure touches are passed through to underlying views.
            tapGesture.cancelsTouchesInView = false
            panGesture.cancelsTouchesInView = false

            window.addGestureRecognizer(tapGesture)
            window.addGestureRecognizer(panGesture)
        }
    }

    /// Starts the inactivity timer.
    ///
    /// The timer checks for inactivity at regular intervals. If the elapsed time
    /// since the last activity exceeds the specified timeout, the `isInactive`
    /// property is set to `true`.
    private func startTimer() {
        // Cancel any existing timer before starting a new one.
        stopTimer()

        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: timeout.seconds)
        timer?.setEventHandler { [weak self] in
            self?.checkInactivity()
        }

        timer?.resume()
    }

    /// Stops the inactivity timer.
    ///
    /// Cancels the active timer and releases its resources.
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    /// Checks whether the inactivity timeout has been reached.
    ///
    /// If the elapsed time since the last detected activity exceeds the timeout,
    /// the `isInactive` property is set to `true`.
    private func checkInactivity() {
        if !isInactive, lastActivityTime.hasElapsed(timeout) {
            isInactive = true
            stopTimer()
        }
    }

    /// Handles user activity events.
    ///
    /// If user activity is detected and the app is not inactive, this method
    /// updates the last recorded activity time to postpone the timeout.
    private func onActivityDetected() {
        guard !isInactive else {
            return
        }

        lastActivityTime.reset()
        startTimer()
    }

    /// Resets the inactivity timer.
    ///
    /// Updates the last recorded activity time to now and ensures the timer
    /// continues monitoring from the reset point.
    public func reset() {
        isInactive = false
        lastActivityTime.reset()
        startTimer()
    }
}
