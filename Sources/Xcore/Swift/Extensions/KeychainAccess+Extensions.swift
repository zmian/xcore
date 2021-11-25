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

extension Keychain {
    public static func keychain(
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
