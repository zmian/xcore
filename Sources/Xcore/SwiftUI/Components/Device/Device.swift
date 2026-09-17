//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An object representing the device.
@dynamicMemberLookup
public final class Device: ObservableObject, Sendable {
    /// An object that represents the current device.
    public static let current = Device()

    /// Returns the display associated with the supplied scene.
    @MainActor
    public func screen(in scene: UIWindowScene) -> Screen {
        Screen(scene: scene)
    }

    /// An enumeration that indicate the interface type for the device.
    public var userInterfaceIdiom: UserInterfaceIdiom {
        .current
    }

    public static subscript<T>(dynamicMember keyPath: KeyPath<Device, T>) -> T {
        current[keyPath: keyPath]
    }

    private init() {}
}

// MARK: - Operating System Information

extension Device {
    /// The name of the operating system running on the device (e.g., iOS).
    public var osName: String {
        MainActor.runImmediately {
            #if os(iOS) || os(tvOS) || os(visionOS) || targetEnvironment(macCatalyst)
            return UIDevice.current.systemName
            #elseif os(watchOS)
            return WKInterfaceDevice.current().systemName
            #elseif os(macOS)
            return "macOS"
            #else
            return "Unknown"
            #endif
        }
    }

    /// The current version of the operating system.
    public var osVersion: OperatingSystemVersion {
        ProcessInfo.processInfo.operatingSystemVersion
    }
}

// MARK: - Environment Support

extension EnvironmentValues {
    /// An object representing the device.
    @Entry public var device: Device = .current
}
