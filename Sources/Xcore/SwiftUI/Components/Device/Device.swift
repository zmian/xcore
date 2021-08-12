//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An object representing the device.
@dynamicMemberLookup
public final class Device: ObservableObject {
    /// An object that represents the current device.
    public static let current = Device()

    /// Returns the screen object representing the device’s screen.
    public var screen: Screen {
        .main
    }

    /// An enumeration that indicate the interface type for the device.
    public var userInterfaceIdiom: UserInterfaceIdiom {
        .current
    }

    public static subscript<T>(dynamicMember keyPath: KeyPath<Device, T>) -> T {
        current[keyPath: keyPath]
    }

    private var cancellable: AnyCancellable?

    private init() {
        #if os(iOS)
        cancellable = screen
            .objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        #endif
    }
}

// MARK: - Operating System Information

extension Device {
    /// The name of the operating system running on the device (e.g., iOS).
    public var osName: String {
        #if os(iOS) || os(tvOS)
        return UIDevice.current.systemName
        #elseif os(watchOS)
        return WKInterfaceDevice.current().systemName
        #elseif os(macOS)
        #warning("TODO: Implement")
        return "macOS"
        #endif
    }

    /// The current version of the operating system.
    public var osVersion: OperatingSystemVersion {
        ProcessInfo.shared.operatingSystemVersion
    }
}

// MARK: - Environment Support

extension EnvironmentValues {
    private struct DeviceKey: EnvironmentKey {
        static var defaultValue: Device = .current
    }

    /// An object representing the device.
    public var device: Device {
        get { self[DeviceKey.self] }
        set { self[DeviceKey.self] = newValue }
    }
}
