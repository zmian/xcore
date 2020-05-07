//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension HTTPCookieStorage {
    /// Removes all cookies from the storage.
    public func deleteCookies() {
        cookies?.forEach {
            deleteCookie($0)
        }
    }

    /// Stores given list of cookies in the cookie storage if the cookie accept
    /// policy permits.
    ///
    /// The cookies replace existing cookies with the same name, domain, and path,
    /// if they exists in the cookie storage. This method accepts the cookies only
    /// if the storage’s cookie accept policy is `HTTPCookie.AcceptPolicy.always` or
    /// `HTTPCookie.AcceptPolicy.onlyFromMainDocumentDomain`. The cookies are
    /// ignored if the storage’s cookie accept policy is
    /// `HTTPCookie.AcceptPolicy.never`.
    ///
    /// - Parameter cookies: The cookies to store.
    public func setCookies(_ cookies: [HTTPCookie]) {
        cookies.forEach {
            setCookie($0)
        }
    }
}

extension HTTPCookie {
    /// A boolean value that indicates whether the cookie is expired.
    ///
    /// This value is `false` if there is no specific expiration date, as with
    /// session-only cookies. The expiration date is compared to the current date to
    /// determine if the cookie is expired.
    public var isExpired: Bool {
        guard let expiresDate = expiresDate else {
            return false
        }

        if expiresDate < Date() {
            return true
        }

        return false
    }
}
