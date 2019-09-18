//
// AdaptiveURL.swift
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

public struct AdaptiveURL: UserInfoContainer {
    /// The title of the URL.
    public let title: String
    public let url: URL?
    /// Additional info which may be used to describe the url further.
    public var userInfo: UserInfo

    /// Initialize an instance of adaptive URL.
    ///
    /// - Parameters:
    ///   - title: The title of the URL.
    ///   - url: The url.
    public init(title: String, url: URL?, userInfo: UserInfo = [:]) {
        self.title = title
        self.url = url
        self.userInfo = userInfo
    }
}

// MARK: - UserInfo

extension UserInfoKey where Type == AdaptiveURL {
    /// A boolean property indicating whether the URL content should adapt app
    /// appearance.
    public static var shouldAdaptAppearance: AdaptiveURL.UserInfoKey { return #function }
}

extension AdaptiveURL {
    /// A boolean property indicating whether the URL content should adapt app
    /// appearance.
    public var shouldAdaptAppearance: Bool {
        get { return self[userInfoKey: .shouldAdaptAppearance, default: false] }
        set { self[userInfoKey: .shouldAdaptAppearance] = newValue }
    }
}
