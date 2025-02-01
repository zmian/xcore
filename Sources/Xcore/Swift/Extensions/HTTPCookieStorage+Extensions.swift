//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension HTTPCookieStorage {
    /// Removes all cookies from the storage.
    public func deleteCookies() {
        cookies?.forEach(deleteCookie)
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
        cookies.forEach(setCookie)
    }
}

extension HTTPCookie {
    /// A Boolean property indicating whether the cookie has expired.
    ///
    /// This property returns `true` if the cookie has an expiration date that is in
    /// the past. If the cookie does not have an expiration date (i.e., it is a
    /// session-only cookie), this property returns `false`.
    public var isExpired: Bool {
        expiresDate.map { $0 < Date() } ?? false
    }
}
