//
// UserInfoKey.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

// MARK: - UserInfoKey

public struct UserInfoKey<Type>: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension UserInfoKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension UserInfoKey: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

extension UserInfoKey: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return rawValue
    }
}

extension UserInfoKey: Hashable {}

extension UserInfoKey: Codable { }

// MARK: - UserInfoContainer

public protocol UserInfoContainer {
    typealias UserInfoKey = Xcore.UserInfoKey<Self>
    typealias UserInfo = [UserInfoKey: Any]
    var userInfo: UserInfo { get set }
}

extension UserInfoContainer {
    public subscript<T>(userInfoKey key: UserInfoKey) -> T? {
        get { return userInfo[key] as? T }
        set { userInfo[key] = newValue }
    }

    public subscript<T>(userInfoKey key: UserInfoKey, default defaultValue: @autoclosure () -> T) -> T {
        return self[userInfoKey: key] ?? defaultValue()
    }
}
