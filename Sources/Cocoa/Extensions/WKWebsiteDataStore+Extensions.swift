//
// WKWebsiteDataStore+Extensions.swift
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

import WebKit

extension WKWebsiteDataStore {
    public enum RemoveDataType {
        /// All the available data types.
        case all

        /// Only cache.
        case cache

        fileprivate var dataTypes: Set<String> {
            switch self {
                case .all:
                    return WKWebsiteDataStore.allWebsiteDataTypes()
                case .cache:
                    return WKWebsiteDataStore.allWebsiteCacheTypes()
            }
        }
    }

    public func remove(_ type: RemoveDataType, _ completion: (() -> Void)? = nil) {
        fetchDataRecords(ofTypes: type.dataTypes) { [weak self] records in
            self?.removeData(ofTypes: type.dataTypes, for: records) {
                completion?()
            }
        }
    }
}

extension WKWebsiteDataStore {
    private static func allWebsiteCacheTypes() -> Set<String> {
        var result: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeOfflineWebApplicationCache
        ]

        if #available(iOS 11.3, *) {
            result.insert(WKWebsiteDataTypeFetchCache)
        }

        return result
    }
}
