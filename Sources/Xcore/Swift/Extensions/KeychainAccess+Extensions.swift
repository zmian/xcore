//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

extension KeychainAccess.Keychain {
    public func policy(_ policy: AuthenticationPolicy) -> Keychain {
        #if targetEnvironment(simulator)
        // Keychain authentication policies aren't supported in the Simulator.
        //
        // Attempting to store any Keychain item with an authentication policy will be
        // silently ignored by the Simulator. Thus, in Simulator environment skip
        // setting any policy.
        return self
        #else
        if policy == .none {
            return self
        } else {
            return accessibility(accessibility, authenticationPolicy: policy)
        }
        #endif
    }
}

extension KeychainAccess.AuthenticationPolicy: Hashable {}

// MARK: - Inits

extension KeychainAccess.Keychain {
    /// A keychain with `service` set to bundle identifier with ".intents" removed
    /// and `accessibility` set to `whenUnlockedThisDeviceOnly`.
    public static func `default`(
        accessGroup: String,
        policy: AuthenticationPolicy = .none
    ) -> Keychain {
        Keychain(
            service: (Bundle.main.bundleIdentifier ?? "").replacing(".intents", with: ""),
            accessGroup: accessGroup
        )
        .accessibility(.whenUnlockedThisDeviceOnly)
        .policy(policy)
    }
}

// MARK: - AuthenticationPolicy

extension KeychainAccess.AuthenticationPolicy {
    /// Constraint to access an item with either `biometryCurrentSet` or device
    /// passcode.
    ///
    /// Touch ID must be available and enrolled with at least one finger, or Face ID
    /// available and enrolled. The item is invalidated if fingers are added or
    /// removed for Touch ID, or if the user re-enrolls for Face ID.
    public static let userPresenceCurrentSet: Self = [.biometryCurrentSet, .or, .devicePasscode]
}
