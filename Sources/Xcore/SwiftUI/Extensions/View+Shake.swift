//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Adds an action to perform when the user shakes the device.
    ///
    /// - Parameter action: The action to perform when the user shakes the device.
    ///
    /// - Returns: A view that triggers `action` when the user shakes the device.
    public func onDeviceShake(perform action: @escaping (() -> Void)) -> some View {
        modifier(DeviceShakeViewModifier(action: action))
    }
}

// MARK: - ViewModifier

/// A view modifier that detects user shaking the device and calls the given
/// action closure.
@MainActor
private struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .task {
                for await _ in NotificationCenter.async(UIDevice.userDidShakeDeviceNotification) {
                    action()
                }
            }
    }
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.post(UIDevice.userDidShakeDeviceNotification)
        }
    }
}

extension UIDevice {
    /// A notification that posts when the user shakes the device.
    fileprivate static let userDidShakeDeviceNotification = Notification.Name(rawValue: "xcore.userDidShakeDeviceNotification")
}
