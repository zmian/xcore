//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import WebKit

extension WKWebsiteDataStore {
    public enum DataType {
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

    public func remove(_ type: DataType, _ completion: (() -> Void)? = nil) {
        Task { @MainActor in
            let records = await dataRecords(ofTypes: type.dataTypes)
            await removeData(ofTypes: type.dataTypes, for: records)
            completion?()
        }
    }
}

// MARK: - AllWebsiteCacheTypes

extension WKWebsiteDataStore {
    private static func allWebsiteCacheTypes() -> Set<String> {
        [
            WKWebsiteDataTypeFetchCache,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeOfflineWebApplicationCache
        ]
    }
}
