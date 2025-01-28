//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import UIKit

/// Monitors user inactivity and toggles `isInactive` property after a specified
/// timeout.
///
/// The `InactivityDetector` monitors user interaction through gesture
/// recognizers and app lifecycle events. It uses a monotonic clock to track
/// elapsed time, ensuring accurate tracking even if the system clock changes.
///
/// Use the `isInactive` property in SwiftUI to reactively display a lock screen
/// or take any other action when the timeout is reached.
///
/// **Usage**
///
/// ```swift
/// @main
/// struct ExampleApp: App {
///     @State private var inactivityDetector = InactivityDetector(timeout: 5 * 60)
///
///     var body: some Scene {
///         WindowGroup {
///             ZStack {
///                 if inactivityDetector.isInactive {
///                     Text("App Locked")
///                 } else {
///                     Text("Welcome to the App!")
///                 }
///             }
///         }
///     }
/// }
/// ```
///
/// - Note: Uses monotonic timer source that won't ever jump forward or backward
///   (due to NTP or Daylight Savings Time updates).
@Observable
@MainActor
final class InactivityDetector {
    private var notificationToken: NSObjectProtocol?
    private var timer: DispatchSourceTimer?
    private let lastActivityUptime: SystemUptime
    private let timeout: TimeInterval

    /// Indicates whether the inactivity timeout has been reached.
    ///
    /// This property automatically notifies SwiftUI when its value changes.
    var isInactive: Bool = false

    /// Creates an instance of `InactivityDetector` with a timeout duration.
    ///
    /// - Parameter timeout: The time interval (in seconds) after which inactivity
    ///   is detected.
    init(timeout: TimeInterval = 5 * 60) {
        self.timeout = timeout
        self.lastActivityUptime = .init()

        setupObservers()
        startTimer()
    }

    /// Sets up observers to detect user activity.
    ///
    /// Observes app lifecycle events and adds gesture recognizers to the app's main
    /// window to monitor user interaction.
    private func setupObservers() {
        // Observing app lifecycle events.
        notificationToken = NotificationCenter.observe(UIApplication.willEnterForegroundNotification) { [weak self] _ in
            DispatchQueue.main.async { [weak self] in
                self?.checkInactivity()
            }
        }

        // Adding gesture recognizers to the main window for detecting touches.
        // Resets the activity timer when user activity is detected.
        if let window = UIApplication.sharedOrNil?.firstSceneKeyWindow {
            let tapGesture = UITapGestureRecognizer { [weak self] sender in
                self?.resetActivityTimer()
            }

            let panGesture = UIPanGestureRecognizer { [weak self] sender in
                self?.resetActivityTimer()
            }

            tapGesture.cancelsTouchesInView = false
            panGesture.cancelsTouchesInView = false
            window.addGestureRecognizer(tapGesture)
            window.addGestureRecognizer(panGesture)
        }
    }

    /// Starts the timer to monitor inactivity.
    ///
    /// The timer checks for inactivity at 1-second intervals. If the elapsed time
    /// exceeds the specified timeout, the `isInactive` property is set to `true`.
    private func startTimer() {
        stopTimer() // Ensure no duplicate timers are running.

        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now(), repeating: timeout)
        timer?.setEventHandler { [weak self] in
            self?.checkInactivity()
        }

        timer?.resume()
    }

    /// Stops the inactivity timer.
    ///
    /// This method cancels the active timer, releasing its resources.
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    /// Checks whether the inactivity timeout has been reached.
    ///
    /// If the elapsed time since the last recorded activity exceeds the specified
    /// timeout, the `isInactive` property is set to `true`.
    private func checkInactivity() {
        if lastActivityUptime.elapsed(timeout) {
            isInactive = true
            stopTimer()
        } else {
            isInactive = false
            startTimer()
        }
    }

    /// Resets the inactivity timer.
    ///
    /// This method updates the last recorded activity time to the current time,
    /// ensuring that the timeout is postponed.
    func resetActivityTimer() {
        lastActivityUptime.saveValue()
        if isInactive {
            isInactive = false
            startTimer()
        }
    }
}
