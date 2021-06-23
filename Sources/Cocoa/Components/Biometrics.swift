//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import LocalAuthentication

// MARK: - Kind

extension Biometrics {
    public enum Kind {
        case none
        case touchID
        case faceID

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
            }
        }
    }
}

public struct Biometrics {
    /// Indicates that the device owner can authenticate using biometry (e.g.,
    /// Touch ID or Face ID).
    public var isAvailable: Bool {
        LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

    /// The type of biometric authentication supported.
    ///
    /// - Note: This property returns the actual capability of the device regardless
    /// of the permission status. For example, Face ID requires permission prompt.
    /// If user denies the permission, then the returned value is still `.faceID`.
    /// If you need to check if biometrics authentication is available then use
    /// `UIDevice.current.biometrics.isAvailable`.
    public var kind: Kind {
        let kind = Kind()

        guard kind == .none else {
            return kind
        }

        return UIDevice.current.modelType.screenSize.iPhoneXSeries ? .faceID : .touchID
    }
}

// MARK: - Authenticate

extension Biometrics {
    /// Evaluates the user authentication with biometry policy.
    ///
    /// - Parameter completion: A closure that is executed when policy evaluation
    ///                         finishes.
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
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
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
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: " ") { success, error in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}

// MARK: - UIDevice

extension UIDevice {
    public var biometrics: Biometrics {
        .init()
    }
}
