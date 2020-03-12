//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol InterstitialDisplayTimestampStorage {
    var value: [String: TimeInterval] { get set }
    func save()
}

extension Interstitial {
    final class DisplayTimestamp {
        private var storage: InterstitialDisplayTimestampStorage

        init(storage: InterstitialDisplayTimestampStorage) {
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
}
