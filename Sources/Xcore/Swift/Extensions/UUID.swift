//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension UUID {
    /// A `UUID` instance representing an **all-zero** UUID
    /// (`00000000-0000-0000-0000-000000000000`).
    ///
    /// This is useful as a placeholder UUID in cases where a valid UUID is required
    /// but no actual value exists.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let id = UUID.zero
    /// print(id) // 00000000-0000-0000-0000-000000000000
    /// ```
    public static let zero = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!

    /// Returns the byte array representation of `self`.
    ///
    /// The resulting array consists of 16 bytes in **little-endian** order, making
    /// it useful for serialization, hashing, and low-level binary operations.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let uuid = UUID()
    /// let uuidBytes = uuid.bytes
    /// print(uuidBytes) // [43, 123, 210, 15, ...]
    /// ```
    public var bytes: [UInt8] {
        [
            uuid.0,
            uuid.1,
            uuid.2,
            uuid.3,
            uuid.4,
            uuid.5,
            uuid.6,
            uuid.7,
            uuid.8,
            uuid.9,
            uuid.10,
            uuid.11,
            uuid.12,
            uuid.13,
            uuid.14,
            uuid.15
        ]
    }
}
