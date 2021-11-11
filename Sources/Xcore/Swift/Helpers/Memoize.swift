//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Returns a modified closure that emits the latest non-nil value
/// if the original closure would return nil
///
/// - SeeAlso: https://github.com/Thomvis/Construct/blob/main/Construct/Foundation/Memoize.swift
public func replayNonNil<A, B>(_ f: @escaping (A) -> B?) -> (A) -> B? {
    var memo: B? = nil
    return {
        if let res = f($0) {
            memo = res
            return res
        }
        return memo
    }
}

/// Creates a closure (T?) -> T? that returns last non-`nil` T passed to it.
///
/// - SeeAlso: https://github.com/Thomvis/Construct/blob/main/Construct/Foundation/Memoize.swift
public func replayNonNil<T>() -> (T?) -> T? {
    replayNonNil { $0 }
}
