//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import LocalAuthentication

// MARK: - Kind

extension Biometrics {
    public enum Kind: Sendable, Hashable {
        case none
        case touchID
        case faceID
        case opticID

        fileprivate init() {
            let context = LAContext()
            // `context.biometryType` property is set only after the call to
            // `canEvaluatePolicy(_:error:)` method, and is set no matter what the call
            // returns.
            _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)

            switch context.biometryType {
                case .touchID:
                    self = .touchID
                case .faceID:
                    self = .faceID
                case .opticID:
                    self = .opticID
                case .none:
                    self = .none
                @unknown default:
                    warnUnknown(context.biometryType)
                    self = .none
            }
        }

        /// The name of the biometry authentication, "Touch ID" or "Face ID"; otherwise,
        /// an empty string.
        public var displayName: String {
            switch self {
                case .none:
                    ""
                case .touchID:
                    "Touch ID"
                case .faceID:
                    "Face ID"
                case .opticID:
                    "Optic ID"
            }
        }

        /// The asset associated with biometry authentication.
        public var assetIdentifier: SystemAssetIdentifier {
            switch self {
                case .none:
                    return ""
                case .touchID:
                    return .touchid
                case .faceID:
                    return .faceid
                case .opticID:
                    if #available(iOS 17.0, *) {
                        return .opticid
                    } else {
                        return .faceid
                    }
            }
        }
    }
}

// MARK: - Biometrics

/// A structure representing the biometrics for the device.
public struct Biometrics: Sendable {
    /// Indicates that the device owner can authenticate using biometry (e.g.,
    /// Touch ID or Face ID).
    public var isAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// The type of biometric authentication supported.
    ///
    /// - Note: This property returns the actual capability of the device regardless
    ///   of the permission status. For example, Face ID requires permission prompt.
    ///   If user denies the permission, then the returned value is still `.faceID`.
    ///   If you need to check if biometrics authentication is available then use
    ///   `Device.biometrics.isAvailable`.
    @MainActor public var kind: Kind {
        let kind = Kind()

        guard kind == .none else {
            return kind
        }

        if UserInterfaceIdiom.current == .vision {
            return .opticID
        }

        return Device.screen.referenceSize.iPhoneXSeries ? .faceID : .touchID
    }
}

// MARK: - Device

extension Device {
    public var biometrics: Biometrics {
        .init()
    }
}

// MARK: - Errors

extension LAError: @retroactive CustomStringConvertible {
    public var description: String {
        switch code {
            case .appCancel:
                "appCancel"
            case .userCancel:
                "userCancel"
            case .systemCancel:
                "systemCancel"
            case .biometryLockout, .touchIDLockout:
                "biometryLockout"
            case .biometryNotAvailable, .touchIDNotAvailable:
                "biometryNotAvailable"
            case .biometryNotEnrolled, .touchIDNotEnrolled:
                "biometryNotEnrolled"
            case .authenticationFailed:
                "authenticationFailed"
            case .invalidContext:
                "invalidContext"
            case .notInteractive:
                "notInteractive"
            case .passcodeNotSet:
                "passcodeNotSet"
            case .userFallback:
                "userFallback"
            case .companionNotAvailable:
                "companionNotAvailable"
            @unknown default:
                "code_\(code.rawValue)"
        }
    }

    public var localizedDescription: String {
        switch code {
            case .appCancel:
                "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
            case .userCancel:
                "Authentication was canceled by user (e.g. tapped Cancel button)."
            case .systemCancel:
                "Authentication was canceled by system (e.g. another application went to foreground)."
            case .biometryLockout, .touchIDLockout:
                "Authentication was not successful because there were too many failed biometry attempts and biometry is now locked. Passcode is now required to unlock biometry."
            case .biometryNotAvailable, .touchIDNotAvailable:
                "Authentication could not start because biometry is not available on the device."
            case .biometryNotEnrolled, .touchIDNotEnrolled:
                "Authentication could not start because biometry has no enrolled identities."
            case .authenticationFailed:
                "Authentication was not successful because user failed to provide valid credentials."
            case .invalidContext:
                "LAContext passed to this call has been previously invalidated."
            case .notInteractive:
                "Authentication failed because it would require showing UI which has been forbidden by using \"interactionNotAllowed\" property."
            case .passcodeNotSet:
                "Authentication could not start because passcode is not set on the device."
            case .userFallback:
                "Authentication was canceled because the user tapped the fallback button (Enter Password)."
            case .companionNotAvailable:
                "Authentication could not start because there was no paired companion device nearby."
            @unknown default:
                "Authentication failed with reason code \(code.rawValue)."
        }
    }
}
