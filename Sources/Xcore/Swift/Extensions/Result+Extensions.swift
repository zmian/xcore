//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Result where Success == Void {
    /// A success, storing a `Success` value.
    public static var success: Self {
        .success(())
    }
}

extension Result {
    /// Returns the value associated with `.success` case.
    public var value: Success? {
        switch self {
            case let .success(value):
                return value
            default:
                return nil
        }
    }

    /// Returns the error associated with `.failure` case.
    public var error: Failure? {
        switch self {
            case let .failure(error):
                return error
            default:
                return nil
        }
    }
}
