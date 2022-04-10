//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension AppStatus {
    /// An enumeration representing session state of the app.
    public enum SessionState: Hashable {
        /// Keychain has fully authorized access token and user must re-authenticate
        /// using biometrics or device passcode to unlock it.
        case locked

        /// The current user's session is unlocked and can use the app without any
        /// further authentication.
        case unlocked

        /// There is no active session; the user is signed out.
        case signedOut

        /// Determines whether `self` can be transitioned to the provided state.
        public func canTransition(to other: SessionState) -> Bool {
            switch (self, other) {
                case (.locked, .unlocked),
                     (.locked, .signedOut),
                     (.unlocked, .locked),
                     (.unlocked, .signedOut),
                     (.signedOut, .unlocked):
                    return true
                case (.locked, .locked),
                     (.unlocked, .unlocked),
                     (.signedOut, .signedOut),
                     (.signedOut, .locked):
                    return false
            }
        }
    }
}
