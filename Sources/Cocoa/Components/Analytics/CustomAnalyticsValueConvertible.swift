//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol CustomAnalyticsValueConvertible {
    var analyticsValue: String { get }
}

// MARK: - Auto Implementation for RawRepresentable

extension CustomAnalyticsValueConvertible where Self: RawRepresentable, RawValue == String {
    public var analyticsValue: String {
        rawValue.snakecased()
    }
}

// MARK: - Built-in

extension Biometrics.Kind: CustomAnalyticsValueConvertible {
    public var analyticsValue: String {
        switch self {
            case .none:
                return "none"
            case .touchID:
                return "touch_id"
            case .faceID:
                return "face_id"
        }
    }
}

extension Bool: CustomAnalyticsValueConvertible {
    public var analyticsValue: String {
        self ? "true" : "false"
    }
}
