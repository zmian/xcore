//
// DisplayTimestampPreference.swift
//
// Copyright © 2018 Xcore
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

public protocol DisplayTimestampPreferenceStorage {
    var value: [String: TimeInterval] { get set }
    func save()
}

final class DisplayTimestampPreference {
    private var storage: DisplayTimestampPreferenceStorage

    init(storage: DisplayTimestampPreferenceStorage) {
        self.storage = storage
    }

    // MARK: - API

    func removeAll() {
        storage.value = [:]
    }

    func setDisplay(_ displayed: Bool, id: String) {
        storage.value[id] = displayed ? Date().timeIntervalSinceReferenceDate : nil
        storage.save()
    }

    func contains(_ id: String, before replayDelay: TimeInterval?) -> Bool {
        // If replay delay is `nil` the functionality is not enabled (item is shown
        // always). If timestamp is `nil`, this is the first time the user sees this
        // item.
        guard let replayDelay = replayDelay, let timestamp = storage.value[id] else {
            return false
        }

        // If replay delay is less than 0 then the item is only shown once.
        guard replayDelay > 0 else {
            return true
        }

        // Otherwise, replay delay is used to decide whether the item is displayed.
        return (Date().timeIntervalSinceReferenceDate - timestamp) < replayDelay
    }

    // MARK: - Convenience API

    func setDisplay<T>(_ displayed: Bool, id: T) where T: RawRepresentable, T.RawValue == String {
        setDisplay(displayed, id: id.rawValue)
    }

    func contains<T>(_ id: T, before replayDelay: TimeInterval?) -> Bool where T: RawRepresentable, T.RawValue == String {
        contains(id.rawValue, before: replayDelay)
    }
}
