//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }
}
