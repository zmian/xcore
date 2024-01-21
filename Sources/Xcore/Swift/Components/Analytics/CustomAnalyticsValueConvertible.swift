//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type with a customized textual representation for analytics purpose.
public protocol CustomAnalyticsValueConvertible {
    /// A stable textual representation of this instance that is suitable for
    /// analytics purpose.
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
            case .opticID:
                return "optic_id"
        }
    }
}

extension Bool: CustomAnalyticsValueConvertible {
    public var analyticsValue: String {
        self ? "true" : "false"
    }
}
