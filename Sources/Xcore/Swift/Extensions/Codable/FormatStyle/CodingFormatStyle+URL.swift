//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct URLCodingFormatStyle: CodingFormatStyle {
    private let allowedCharacters: CharacterSet?

    fileprivate init(allowed allowedCharacters: CharacterSet?) {
        self.allowedCharacters = allowedCharacters
    }

    public func decode(_ value: AnyCodable) throws -> URL {
        if let value = value.value as? URL {
            return value
        }

        guard
            let value = value.value as? String,
            let value = value.removingPercentEncoding,
            !value.isBlank
        else {
            throw CodingFormatStyleError.invalidValue
        }

        if allowedCharacters == nil, let url = URL(string: value) {
            return url
        }

        if
            let allowedCharacters = allowedCharacters,
            let escapedString = value.urlEscaped(allowed: allowedCharacters),
            let url = URL(string: escapedString)
        {
            return url
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: URL) throws -> AnyCodable {
        AnyCodable(value.absoluteString)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == URLCodingFormatStyle {
    public static var url: Self {
        url(allowed: .urlQueryAllowed)
    }

    public static func url(allowed allowedCharacters: CharacterSet) -> Self {
        Self(allowed: allowedCharacters)
    }
}

extension EncodingFormatStyle where Self == URLCodingFormatStyle {
    public static var url: Self {
        Self(allowed: nil)
    }
}
