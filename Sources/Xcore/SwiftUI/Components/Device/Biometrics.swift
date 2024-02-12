//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import LocalAuthentication

// MARK: - Kind

extension Biometrics {
    public enum Kind {
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
                    return ""
                case .touchID:
                    return "Touch ID"
                case .faceID:
                    return "Face ID"
                case .opticID:
                    return "Optic ID"
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
public struct Biometrics {
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
    public var kind: Kind {
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

// MARK: - Authenticate

extension Biometrics {
    /// Evaluates the user authentication with biometry policy.
    ///
    /// - Parameter completion: A closure that is executed when policy evaluation
    ///   finishes.
    public func authenticate(_ completion: @escaping (_ success: Bool) -> Void) {
        guard isAvailable else {
            return
        }

        // Using blank string " " here for `localizedReason` because `localizedReason`
        // is not used for Face ID authentication.
        //
        // - SeeAlso: `NSFaceIDUsageDescription` in `Info.plist` file.
        let context = LAContext()
        context.localizedFallbackTitle = ""
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    public func requestPermission(_ completion: @escaping () -> Void) {
        guard isAvailable else {
            return
        }

        let context = LAContext()
        context.localizedFallbackTitle = ""
        context.interactionNotAllowed = true
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { _, _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

// MARK: - Device

extension Device {
    public var biometrics: Biometrics {
        .init()
    }
}

// MARK: - Errors

extension LAError: CustomStringConvertible {
    public var description: String {
        switch code {
            case .appCancel:
                return "appCancel"
            case .userCancel:
                return "userCancel"
            case .systemCancel:
                return "systemCancel"
            case .biometryLockout:
                return "biometryLockout"
            case .biometryNotAvailable:
                return "biometryNotAvailable"
            case .biometryNotEnrolled:
                return "biometryNotEnrolled"
            case .authenticationFailed:
                return "authenticationFailed"
            case .invalidContext:
                return "invalidContext"
            case .notInteractive:
                return "notInteractive"
            case .passcodeNotSet:
                return "passcodeNotSet"
            case .userFallback:
                return "userFallback"
            case .watchNotAvailable:
                return "watchNotAvailable"
            default:
                return "code_\(code.rawValue)"
        }
    }

    public var localizedDescription: String {
        switch code {
            case .appCancel:
                return "Authentication was canceled by application (e.g. invalidate was called while authentication was in progress)."
            case .userCancel:
                return "Authentication was canceled by user (e.g. tapped Cancel button)."
            case .systemCancel:
                return "Authentication was canceled by system (e.g. another application went to foreground)."
            case .biometryLockout:
                return "Authentication was not successful because there were too many failed biometry attempts and biometry is now locked. Passcode is now required to unlock biometry."
            case .biometryNotAvailable:
                return "Authentication could not start because biometry is not available on the device."
            case .biometryNotEnrolled:
                return "Authentication could not start because biometry has no enrolled identities."
            case .authenticationFailed:
                return "Authentication was not successful because user failed to provide valid credentials."
            case .invalidContext:
                return "LAContext passed to this call has been previously invalidated."
            case .notInteractive:
                return "Authentication failed because it would require showing UI which has been forbidden by using \"interactionNotAllowed\" property."
            case .passcodeNotSet:
                return "Authentication could not start because passcode is not set on the device."
            case .userFallback:
                return "Authentication was canceled because the user tapped the fallback button (Enter Password)."
            case .watchNotAvailable:
                return "An attempt to authenticate with Apple Watch failed."
            default:
                return "Authentication failed with reason code \(code.rawValue)."
        }
    }
}
