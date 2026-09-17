//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// An enumeration that indicate the interface type for the device.
public enum UserInterfaceIdiom: Sendable, Hashable, CustomStringConvertible {
    /// An interface designed for an in-car experience.
    case carPlay

    /// An interface designed for the Mac.
    case mac

    /// An interface designed for iPad.
    case pad

    /// An interface designed for iPhone and iPod touch.
    case phone

    /// An interface designed for tvOS and Apple TV.
    case tv

    /// An interface designed for Apple Watch.
    case watch

    /// An interface designed for Apple Vision.
    case vision

    /// An unspecified idiom.
    case unspecified

    public var description: String {
        switch self {
            case .carPlay: "CarPlay"
            case .mac: "Mac"
            case .pad: "iPad"
            case .phone: "iPhone"
            case .tv: "Apple TV"
            case .watch: "Apple Watch"
            case .vision: "Apple Vision"
            case .unspecified: "Unspecified"
        }
    }
}

// MARK: - Current

extension UserInterfaceIdiom {
    /// The style of interface to use on the current device.
    static var current: Self {
        MainActor.runImmediately {
            #if targetEnvironment(macCatalyst)
            return .mac
            #elseif os(iOS) || os(tvOS) || os(visionOS)
            return switch UIDevice.current.userInterfaceIdiom {
                case .carPlay: .carPlay
                case .mac: .mac
                case .pad: .pad
                case .phone: .phone
                case .tv: .tv
                case .vision: .vision
                case .unspecified: .unspecified
                @unknown default:
                #if DEBUG
                fatalError(because: .unknownCaseDetected(UIDevice.current.userInterfaceIdiom))
                #else
                .unspecified
                #endif
            }
            #elseif os(macOS)
            return .mac
            #elseif os(watchOS)
            return .watch
            #endif
        }
    }
}
