//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension NSError {
    /// Appends the given dictionary to the existing `userInfo` dictionary replacing
    /// any existing values with newer ones.
    public func appendingUserInfo(_ userInfo: [String: Any]) -> NSError {
        var newUserInfo = self.userInfo
        newUserInfo.merge(userInfo, strategy: .replaceExisting)

        return .init(
            domain: domain,
            code: code,
            userInfo: newUserInfo
        )
    }
}

extension NSError {
    /// Returns an error with random domain and code.
    public static func random() -> Self {
        .init(domain: .random(), code: .random(), userInfo: nil)
    }
}
