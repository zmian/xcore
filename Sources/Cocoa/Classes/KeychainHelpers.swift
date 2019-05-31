//
// KeychainHelpers.swift
//
// Copyright © 2017 Xcore
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

final public class KeychainHelpers {
    /// A function to get the `kSecClassGenericPassword` item for the given `key` and `prefix`.
    ///
    /// ```swift
    /// KeychainHelpers.get("authToken", prefix: "com.example.ios.")
    /// ```
    public static func get(_ key: String, prefix: String) -> Any? {
        guard let data = items(for: kSecClassGenericPassword as String)["\(prefix)\(key)"] as? Data else {
            return nil
        }

        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let item = unarchiver.decodeObject(forKey: key)
        unarchiver.finishDecoding()
        return item
    }

    /// A function to list all items stored in the keychain for the given class.
    ///
    /// ```swift
    /// let items = KeychainHelpers.items(for: kSecClassGenericPassword as String)
    /// ```
    /// - seealso: https://stackoverflow.com/a/44310869
    public static func items(for secClass: String) -> [String: Any] {
        let query: [CFString: Any] = [
            kSecClass: secClass,
            kSecReturnData: kCFBooleanTrue!,
            kSecReturnAttributes: kCFBooleanTrue!,
            kSecReturnRef: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitAll
        ]

        var result: AnyObject?

        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        guard lastResultCode == noErr, let items = result as? [[String: Any]] else {
            return [:]
        }

        var values = [String: Any]()

        for item in items {
            guard
                let key = item[kSecAttrService as String] as? String,
                let value = item[kSecValueData as String] as? Data
            else { continue }
            values[key] = value
        }

        return values
    }

    /// A function to remove item from the keychain for the given `key`.
    ///
    /// ```swift
    /// KeychainHelpers.remove("com.example.ios.authToken", for: kSecClassGenericPassword as String)
    /// ```
    @discardableResult
    public static func remove(_ key: String, for secClass: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: secClass,
            kSecAttrService: key
        ]

        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }

    /// A function to remove all items from the keychain.
    ///
    /// ```swift
    /// KeychainHelpers.removeAllItems()
    /// ```
    public static func removeAllItems() {
        let secClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]

        for secClass in secClasses {
            let dictionary = [kSecClass: secClass]
            SecItemDelete(dictionary as CFDictionary)
        }
    }

    /// A function to show the raw value for the given `key`.
    ///
    /// ```swift
    /// KeychainHelpers.raw("com.example.ios.authToken")
    /// ```
    public static func raw(_ key: String) -> Any? {
        guard let data = items(for: kSecClassGenericPassword as String)["\(key)"] as? Data else {
            return nil
        }

        do {
            return try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        } catch {
            return nil
        }
    }
}
