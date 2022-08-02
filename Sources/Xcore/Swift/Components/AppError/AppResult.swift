//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A value that represents either a success or a failure as an `AppError`,
/// including an associated value in each case.
public typealias AppResult<Value> = Swift.Result<Value, AppError>
